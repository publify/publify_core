# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyCore::StringExt do
  describe "#to_permalink" do
    it "builds a nice permalink from an accentuated string" do
      expect("L'été s'ra chaud, l'été s'ra chaud".to_permalink)
        .to eq("l-ete-s-ra-chaud-l-ete-s-ra-chaud")
    end

    it "strips html" do
      expect("This <i>is</i> a <b>test</b>".to_permalink)
        .to eq "this-is-a-test"
    end

    it "downcases the string" do
      expect("Article-3".to_permalink).to eq "article-3"
    end

    it "strips trailing special characters" do
      expect("Article 3!?#".to_permalink).to eq "article-3"
    end

    it "replaces special characters with a dash" do
      expect("foo@bar".to_permalink).to eq "foo-bar"
    end

    it "handles more than two words" do
      expect("There is Sex in my Violence!".to_permalink)
        .to eq "there-is-sex-in-my-violence"
    end

    it "strips leading and trailing dashes" do
      expect("-article-".to_permalink).to eq "article"
    end

    it "handles punctuation in the middle of th string" do
      expect("Lorem ipsum dolor sit amet, consectetaur adipisicing elit".to_permalink)
        .to eq "lorem-ipsum-dolor-sit-amet-consectetaur-adipisicing-elit"
    end

    it "drops leading and trailing spaces" do
      expect(" this is a sentence ".to_permalink).to eq("this-is-a-sentence")
    end

    it "compresses multiple spaces to a single space" do
      expect("this is  a sentence".to_permalink).to eq("this-is-a-sentence")
    end

    it "replaces single quotes with a dash" do
      expect("My Cat's Best Friend".to_permalink).to eq "my-cat-s-best-friend"
    end

    it "drops double quotes instead of replacing them with a dash" do
      expect("bar\"baz".to_permalink).to eq "barbaz"
    end
  end
end
