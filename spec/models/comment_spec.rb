# frozen_string_literal: true

require "rails_helper"
require "publify_core/testing_support/dns_mock"

RSpec.describe Comment, type: :model do
  let(:blog) { build_stubbed(:blog) }

  let(:published_article) { build_stubbed(:article, published_at: 1.hour.ago, blog: blog) }

  describe "validations" do
    let(:comment) { described_class.new }

    it "allows an article with open comment window" do
      article = Article.new(blog: blog, allow_comments: true, state: "published",
                            published_at: 1.day.ago)

      expect(comment).to allow_value(article).for(:article)
    end

    it "requires article comment window to be open" do
      article = Article.new(blog: blog, allow_comments: true)

      expect(comment).not_to allow_value(article).for(:article)
        .with_message("Comments are closed")
    end

    it "requires article to be open to comments" do
      article = Article.new(blog: blog, allow_comments: false)

      expect(comment).not_to allow_value(article).for(:article)
        .with_message("Article is not open for comments")
    end
  end

  describe "#permalink_url" do
    let(:comment) { build_stubbed(:comment) }

    it "renders permalink to comment in public part" do
      expect(comment.permalink_url)
        .to eq("#{comment.article.permalink_url}#comment-#{comment.id}")
    end
  end

  describe "#save" do
    it "saves good comment" do
      c = build(:comment, url: "http://www.google.de")
      c.save!
      expect(c.url).to eq "http://www.google.de"
    end

    it "saves spam comment" do
      c = build(:comment, body: 'test <a href="http://fakeurl.com">body</a>')
      c.save!
      expect(c.url).to eq "http://fakeurl.com"
    end

    it "does not save when article comment window is closed" do
      article = build(:article, published_at: 1.year.ago)
      article.blog.sp_article_auto_close = 30
      comment = build(:comment, author: "Old Spammer", body: "Old trackback body",
                                article: article)
      expect(comment.save).to be_falsey
      expect(comment.errors[:article]).not_to be_empty
    end

    it "changes old comment" do
      c = build(:comment, body: "Comment body <em>italic</em> <strong>bold</strong>")
      c.save!
      expect(c.errors).to be_empty
    end

    it "saves a valid comment" do
      c = build(:comment)
      expect(c.save).to be_truthy
      expect(c.errors).to be_empty
    end

    it "does not save with article not allow comment" do
      c = build(:comment, article: build_stubbed(:article, allow_comments: false))
      expect(c.save).not_to be_truthy
      expect(c.errors).not_to be_empty
    end

    it "generates guid" do
      c = build(:comment, guid: nil)
      c.save!
      expect(c.guid.size).to be > 15
    end

    it "preserves urls starting with https://" do
      c = build(:comment, url: "https://example.com/")
      c.save
      expect(c.url).to eq("https://example.com/")
    end

    it "preserves urls starting with http://" do
      c = build(:comment, url: "http://example.com/")
      c.save
      expect(c.url).to eq("http://example.com/")
    end

    it "prepends http:// to urls without protocol" do
      c = build(:comment, url: "example.com")
      c.save
      expect(c.url).to eq("http://example.com")
    end
  end

  describe "#classify_content" do
    def valid_comment(options = {})
      Comment.new({ author: "Bob", article: published_article, body: "nice post",
                    ip: "1.2.3.4" }.merge(options))
    end

    it "rejects spam rbl" do
      comment = valid_comment(
        author: "Spammer",
        body: <<-BODY,
          This is just some random text.
          &lt;a href="http://chinaaircatering.com"&gt;without any senses.&lt;/a&gt;.
          Please disregard.
        BODY
        url: "http://buy-computer.us")
      comment.classify_content
      expect(comment).to be_spammy
      expect(comment).not_to be_status_confirmed
    end

    it "does not define spam a comment rbl with lookup succeeds" do
      comment = valid_comment(author: "Not a Spammer", body: "Useful commentary!",
                              url: "http://www.bofh.org.uk")
      comment.classify_content
      expect(comment).not_to be_spammy
      expect(comment).not_to be_status_confirmed
    end

    it "rejects spam with uri limit" do
      comment =
        valid_comment(author: "Yet Another Spammer",
                      body: <<~HTML,
                        <a href="http://www.one.com/">one</a>
                        <a href="http://www.two.com/">two</a>
                        <a href="http://www.three.com/">three</a>
                        <a href="http://www.four.com/">four</a>
                      HTML
                      url: "http://www.uri-limit.com")
      comment.classify_content
      expect(comment).to be_spammy
      expect(comment).not_to be_status_confirmed
    end

    describe "with feedback moderation enabled" do
      before do
        allow(blog).to receive_messages(sp_global: false, default_moderate_comments: true)
      end

      it "marks comment as presumably spam" do
        comment = described_class.new do |c|
          c.body = "Test foo"
          c.author = "Bob"
          c.article = build_stubbed(:article, blog: blog)
        end

        comment.classify_content

        expect(comment).not_to be_published
        expect(comment).to be_presumed_spam
        expect(comment).not_to be_status_confirmed
      end

      it "marks comment from known user as confirmed ham" do
        comment = described_class.new do |c|
          c.body = "Test foo"
          c.author = "Henri"
          c.article = build_stubbed(:article, blog: blog)
          c.user = build_stubbed(:user)
        end

        comment.classify_content

        expect(comment).to be_published
        expect(comment).to be_ham
        expect(comment).to be_status_confirmed
      end
    end
  end

  it "has good relation" do
    article = build_stubbed(:article)
    comment = build_stubbed(:comment, article: article)
    expect(comment.article).not_to be_nil
    expect(comment.article).to eq article
  end

  describe "change state" do
    it "becomes unpublished if withdrawn" do
      c = build(:comment)
      expect(c).to be_published
      c.withdraw!
      expect(c).not_to be_published
      expect(c).to be_spam
      expect(c).to be_status_confirmed
    end

    it "becomeses confirmed if withdrawn" do
      unconfirmed = build(:comment, state: "presumed_ham")
      expect(unconfirmed).not_to be_status_confirmed
      unconfirmed.withdraw!
      expect(unconfirmed).to be_status_confirmed
    end
  end

  it "has good default filter" do
    create(:blog, text_filter: "markdown", comment_text_filter: "markdown")
    a = create(:comment)
    expect(a.default_text_filter.name).to eq "markdown"
  end

  describe "spam" do
    let!(:comment) { create(:comment, state: "spam") }
    let!(:ham_comment) { create(:comment, state: "ham") }

    it "returns only spam comment" do
      expect(described_class.spam).to eq([comment])
    end
  end

  describe "not_spam" do
    let!(:comment) { create(:comment, state: "spam") }
    let!(:ham_comment) { create(:comment, state: "ham") }
    let!(:presumed_spam_comment) { create(:comment, state: "presumed_spam") }

    it "returns all comment that not_spam" do
      expect(described_class.not_spam).to contain_exactly(ham_comment,
                                                          presumed_spam_comment)
    end
  end

  describe "presumed_spam" do
    let!(:comment) { create(:comment, state: "spam") }
    let!(:ham_comment) { create(:comment, state: "ham") }
    let!(:presumed_spam_comment) { create(:comment, state: "presumed_spam") }

    it "returns only presumed_spam" do
      expect(described_class.presumed_spam).to eq([presumed_spam_comment])
    end
  end

  describe "last_published" do
    let(:date) { DateTime.new(2012, 12, 23, 12, 47).in_time_zone }

    let!(:comments) do
      (1..6).map do |num|
        create(:comment, body: "Comment #{num}", created_at: date + num.days)
      end
    end

    it "returns the last 5 published comments" do
      expect(described_class.last_published.map(&:body))
        .to eq ["Comment 6", "Comment 5", "Comment 4", "Comment 3", "Comment 2"]
    end
  end

  describe "#html" do
    it "renders email addresses in the body" do
      comment = build_stubbed(:comment, body: "foo@example.com")
      expect(comment.html).to match(/mailto:/)
    end

    it "returns an html_safe string" do
      comment = build_stubbed(:comment, body: "Just a comment")
      expect(comment.html).to be_html_safe
    end

    context "with an attempted xss body" do
      let(:comment) do
        described_class.new do |c|
          c.body = "Test foo <script>do_evil();</script>"
          c.author = "Bob"
          c.article = build_stubbed(:article, blog: blog)
        end
      end

      ["", "textile", "markdown", "smartypants", "markdown smartypants"].each do |filter|
        it "rejects with filter '#{filter}'" do
          blog.comment_text_filter = filter

          ActiveSupport::Deprecation.silence do
            expect(comment.html(:body)).not_to include "<script>"
          end
        end
      end
    end

    context "with a comment containing some html" do
      let(:comment) do
        described_class.new do |c|
          c.body = "Test <b>foo</b> <img src=\"https://eviloverlord.com/getmyip.jpg\">"
          c.author = "Bob"
          c.article = build_stubbed(:article, blog: blog)
        end
      end

      ["", "textile", "markdown", "smartypants", "markdown smartypants"].each do |filter|
        it "rejects images but not formatting with filter '#{filter}'" do
          blog.comment_text_filter = filter

          html = comment.html(:body)

          ActiveSupport::Deprecation.silence do
            expect(html).not_to match(/<img/)
            expect(html).to match(%r{<b>foo</b>})
          end
        end
      end
    end

    context "with a markdown comment with italic and bold" do
      let(:comment) { build(:comment, body: "Comment body _italic_ **bold**") }
      let(:blog) { comment.article.blog }

      it "converts the comment markup to html" do
        blog.comment_text_filter = "markdown"
        result = comment.html

        aggregate_failures do
          expect(result).to match(%r{<em>italic</em>})
          expect(result).to match(%r{<strong>bold</strong>})
        end
      end
    end
  end
end
