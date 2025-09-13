# frozen_string_literal: true

require "twitter"
require "json"
require "uri"
require "html_pipeline"
require "html_pipeline/node_filter/mention_filter"

class Note < Content
  include PublifyGuid
  include ConfigManager

  serialize :settings, Hash, coder: YAML

  setting :twitter_id, :string, ""
  setting :in_reply_to_status_id, :string, ""
  setting :in_reply_to_protected, :boolean, false
  setting :in_reply_to_message, :string, ""

  validates :body, presence: true
  validates :permalink, :guid, uniqueness: true

  before_create :create_guid
  after_create :set_permalink, :shorten_url

  scope :published, lambda {
    where(state: "published").where(published_at: ..Time.zone.now).order(default_order)
  }
  default_scope { order(published_at: :desc) }

  TWITTER_FTP_URL_LENGTH = 19
  TWITTER_HTTP_URL_LENGTH = 20
  TWITTER_HTTPS_URL_LENGTH = 21
  TWITTER_LINK_LENGTH = 22

  class TwitterHashtagFilter < HTMLPipeline::NodeFilter
    def after_initialize
      context[:tag_url] ||= "https://twitter.com/search?q=%%23%<tag>s&src=tren&mode=realtime"
    end

    SELECTOR = Selma::Selector.new(match_text_within: "*",
                                   ignore_text_within: ["a"])

    def selector
      SELECTOR
    end

    HASHTAG_PATTERN = /(?<=^|\W)#([-_A-Za-z0-9]+)(?=\W|$)/

    def handle_text_chunk(chunk)
      text = chunk.to_s

      html = text.gsub(HASHTAG_PATTERN) do |match|
        tag = Regexp.last_match(1)
        url = format context[:tag_url], tag: tag
        "<a href=\"#{url}\">#{match}</a>"
      end

      return chunk if html == text

      chunk.replace(html, as: :html)
    end
  end

  class TwitterMentionFilter < HTMLPipeline::NodeFilter::MentionFilter
    def after_initialize
      super
      context[:base_url] ||= "https://twitter.com"
      context[:info_url] ||= "https://foo.com"
    end

    # Override base link creator, removing the class
    def link_to_mentioned_user(base_url, login)
      result[:mentioned_usernames] |= [login]

      url = base_url.dup
      excluded_prefixes = %r{[/(?:~|@]\z}
      url << "/" unless excluded_prefixes.match?(url)

      "<a href=\"#{url << login}\">@#{login}</a>"
    end
  end

  def set_permalink
    self.permalink = "#{id}-#{body.to_permalink[0..79]}" if permalink.blank?
    save
  end

  def categories
    []
  end

  def tags
    []
  end

  def generate_html(field, text = nil)
    if field == :in_reply_to
      helper = PublifyCore::ContentTextHelpers.new
      html = helper.simple_format(text)
      html_postprocess(field, html).to_s
    else
      super
    end
  end

  def html_postprocess(field, html)
    helper = PublifyCore::ContentTextHelpers.new
    html = helper.auto_link(html)

    html = TwitterHashtagFilter.call(html)
    html = TwitterMentionFilter.call(html).to_s
    super
  end

  def truncate(message, length)
    if message[length + 1] == " "
      message[0..length]
    else
      message[0..(message[0..length].rindex(" ") - 1)]
    end
  end

  def twitter_message
    base_message = body.strip_html
    if too_long?("#{base_message} (#{short_link})")
      max_length = 140 - "... (#{redirect.from_url})".length - 1
      "#{truncate(base_message, max_length)}... (#{redirect.from_url})"
    else
      "#{base_message} (#{short_link})"
    end
  end

  # FIXME: This breaks if the user changes or deletes their handle.
  def twitter_url
    File.join("https://twitter.com", user.twitter, "status", twitter_id)
  end

  def send_to_twitter
    return false unless blog.has_twitter_configured?
    return false unless user.has_twitter_configured?

    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key = blog.twitter_consumer_key
      config.consumer_secret = blog.twitter_consumer_secret
      config.access_token = user.twitter_oauth_token
      config.access_token_secret = user.twitter_oauth_token_secret
    end

    begin
      options = {}
      if in_reply_to_status_id && in_reply_to_status_id != ""
        options = { in_reply_to_status_id: in_reply_to_status_id }
        self.in_reply_to_message = twitter.status(in_reply_to_status_id).to_json
      end
      tweet = twitter.update(twitter_message, options)
      self.twitter_id = tweet.attrs[:id_str]
      save
      user.update_twitter_profile_image(tweet.attrs[:user][:profile_image_url])
      true
    rescue StandardError => e
      Rails.logger.error("Error while sending to twitter: #{e}")
      errors.add(:message, e)
      false
    end
  end

  content_fields :body

  def password_protected?
    false
  end

  def access_by?(user)
    user.admin? || user_id == user.id
  end

  def permalink_url(anchor = nil, only_path = false)
    blog.url_for(
      controller: "/notes",
      action: "show",
      permalink: permalink,
      anchor: anchor,
      only_path: only_path)
  end

  def short_link
    path = redirect.from_path
    "#{prefix} #{path}"
  end

  def prefix
    blog.shortener_url.sub(%r{^https?://}, "")
  end

  def published?
    state == "published"
  end

  private

  def too_long?(message)
    uris = URI.extract(message, %w(http https ftp))
    uris << prefix
    uris.each do |uri|
      payload = case uri.split(":")[0]
                when "https"
                  "-" * TWITTER_HTTPS_URL_LENGTH
                when "ftp"
                  "-" * TWITTER_FTP_URL_LENGTH
                else
                  "-" * TWITTER_HTTP_URL_LENGTH
                end
      message = message.gsub(uri, payload)
    end
    message.length > 140
  end
end
