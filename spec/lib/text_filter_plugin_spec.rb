# frozen_string_literal: true

require "rails_helper"

RSpec.describe TextFilterPlugin do
  describe ".available_filters" do
    it "lists only directly usable filters" do
      expect(described_class.available_filters).to contain_exactly(
        PublifyCore::TextFilter::None,
        PublifyCore::TextFilter::Markdown,
        PublifyCore::TextFilter::Smartypants,
        PublifyCore::TextFilter::MarkdownSmartquotes)
    end
  end

  describe ".macro_filters" do
    it "lists no filters" do
      expect(described_class.macro_filters).to be_empty
    end
  end

  shared_examples "a macro class" do
    describe ".attributes_parse" do
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

  describe described_class::MacroPre do
    it_behaves_like "a macro class"

    it "declares itself to be a macropre filter" do
      expect(described_class.filter_type).to eq "macropre"
    end
  end

  describe described_class::MacroPost do
    it_behaves_like "a macro class"

    it "declares itself to be a macropost filter" do
      expect(described_class.filter_type).to eq "macropost"
    end
  end

  describe described_class::Markup do
    it "declares itself to be a markup filter" do
      expect(described_class.filter_type).to eq "markup"
    end
  end
end
