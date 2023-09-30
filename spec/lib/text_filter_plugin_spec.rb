# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextFilterPlugin do
  describe ".available_filters" do
    it "lists only directly usable filters" do
      expect(described_class.available_filters).to contain_exactly(
        PublifyCore::TextFilter::None,
        PublifyCore::TextFilter::Markdown,
        PublifyCore::TextFilter::Smartypants,
        PublifyCore::TextFilter::MarkdownSmartquotes,
        PublifyCore::TextFilter::Twitterfilter)
    end
  end

  describe ".macro_filters" do
    it "lists no filters" do
      expect(described_class.macro_filters).to be_empty
    end
  end

  describe described_class::Macro do
    describe "#self.attributes_parse" do
      it 'parses lang="ruby" to {"lang" => "ruby"}' do
        expect(described_class.attributes_parse('<publify:code lang="ruby">'))
          .to eq("lang" => "ruby")
      end

      it "parses lang='ruby' to {'lang' => 'ruby'}" do
        expect(described_class.attributes_parse("<publify:code lang='ruby'>"))
          .to eq("lang" => "ruby")
      end
    end
  end
end
