# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyCore::TextTransformer do
  describe "#to_permalink" do
    it "builds a nice permalink from an accentuated string" do
      expect(described_class.to_permalink("L'été s'ra chaud, l'été s'ra chaud"))
        .to eq("l-ete-s-ra-chaud-l-ete-s-ra-chaud")
    end
  end

  describe "to_url" do
    it "gives a proper space-less, trimmed URL" do
      expect(described_class.to_url(" this is  a sentence ")).to eq("this-is-a-sentence")
    end

    it "test_strip_title" do
      aggregate_failures do
        expect(described_class.to_url("Article-3")).to eq "article-3"
        expect(described_class.to_url("Article 3!?#")).to eq "article-3"
        expect(described_class.to_url("There is Sex in my Violence!"))
          .to eq "there-is-sex-in-my-violence"
        expect(described_class.to_url("-article-")).to eq "article"
        expect(described_class.to_url("Lorem ipsum dolor sit amet," \
                                      " consectetaur adipisicing elit"))
          .to eq "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit"
        expect(described_class.to_url("My Cat's Best Friend")).to eq "my-cats-best-friend"
      end
    end
  end

  describe "strip_html" do
    it "renders text only" do
      expect(described_class.strip_html("<a href='http://myblog.com'>my blog</a>"))
        .to eq("my blog")
    end

    it "does not remove a > from a numeric comparison" do
      expect(described_class.strip_html("5 < 6 > 4")).to eq("5 < 6 > 4")
    end
  end
end
