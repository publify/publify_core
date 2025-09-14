# frozen_string_literal: true

require "uri"

class Content < ApplicationRecord
  include ContentBase
  include StringLengthLimit

  belongs_to :user, optional: true, touch: true
  belongs_to :blog

  has_one :redirect, dependent: :destroy, inverse_of: :content

  has_many :triggers, as: :pending_item, dependent: :delete_all
  has_many :resources, inverse_of: :content, dependent: :nullify
  has_and_belongs_to_many :tags

  scope :user_id, ->(user_id) { where(user_id: user_id) }
  scope :published, -> { where(state: "published").order(default_order) }
  scope :published_at, lambda { |time_params|
                         published.where(published_at: PublifyTime.delta(*time_params))
                       }
  scope :not_published, -> { where.not(state: "published") }
  scope :drafts, -> { where(state: "draft").order("created_at DESC") }
  scope :no_draft, -> { where.not(state: "draft").order("published_at DESC") }
  scope :searchstring, lambda { |search_string|
    result = where(state: "published")

    tokens = search_string.split(" ").map { |c| "%#{c.downcase}%" }
    tokens.each do |token|
      result = result
        .where("(LOWER(body) LIKE ? OR LOWER(extended) LIKE ? OR LOWER(title) LIKE ?)",
               token, token, token)
    end
    result
  }

  scope :published_at_like, lambda { |date_at|
                              where(published_at: PublifyTime.delta_like(date_at))
                            }

  serialize :whiteboard, coder: YAML

  validates_default_string_length :title, :author, :permalink, :name,
                                  :post_type, :text_filter_name

  def author=(user)
    if user.respond_to?(:login)
      self[:author] = user.login
      self.user = user
    elsif user.is_a?(String)
      self[:author] = user
    end
  end

  def author_name
    if user.present? && user.name.present?
      user.name
    else
      author
    end
  end

  def shorten_url
    return unless published?

    if redirect.present?
      return if redirect.to_path == permalink_url

      redirect.to_path = permalink_url
      redirect.save
    else
      r = Redirect.new(blog: blog)
      r.from_path = r.shorten
      r.to_path = permalink_url
      self.redirect = r
    end
  end

  # TODO: Inline this method
  def self.find_already_published(limit)
    published.limit(limit)
  end

  def self.search_with(params)
    params ||= {}
    scoped = unscoped
    scoped = scoped.searchstring(params[:searchstring]) if params[:searchstring].present?

    if params[:published_at].present? && /(\d\d\d\d)-(\d\d)/ =~ params[:published_at]
      scoped = scoped.published_at_like(params[:published_at])
    end

    if params[:user_id].present? && params[:user_id].to_i > 0
      scoped = scoped.user_id(params[:user_id])
    end

    if params[:published].present?
      scoped = scoped.published if params[:published].to_s == "1"
      scoped = scoped.not_published if params[:published].to_s == "0"
    end

    scoped
  end

  def whiteboard
    self[:whiteboard] ||= {}
  end

  def rss_description
    return "" unless blog.rss_description

    rss_desc = blog.rss_description_text
    rss_desc.gsub!("%author%", author_name)
    rss_desc.gsub!("%blog_url%", blog.base_url)
    rss_desc.gsub!("%blog_name%", blog.blog_name)
    rss_desc.gsub!("%permalink_url%", permalink_url)
    rss_desc
  end

  def short_url
    redirect.from_url if redirect.present?
  end
end
