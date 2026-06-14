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

  shared_examples "an abstract macro class" do
    describe ".filtertext" do
      before do
        allow(described_class).to receive(:macrofilter) do |attrs, content = nil|
          content ||= "NO CONTENT"
          attrs_text = attrs.map { |key, val| "#{key}=#{val}" }.join(", ")
          "#{attrs_text} (#{content})"
        end
        allow(described_class).to receive(:short_name).and_return "code"
      end

      it "parses contentless tags with double-quoted attribute values" do
        expect(described_class.filtertext("<publify:code lang=\"ruby\"/>"))
          .to eq("lang=ruby (NO CONTENT)")
      end

      it "parses contentless tags with single-quoted attribute values" do
        expect(described_class.filtertext("<publify:code lang='ruby'/>"))
          .to eq("lang=ruby (NO CONTENT)")
      end

      it "parses contentful tags with double-quoted attribute values" do
        result = described_class
          .filtertext("<publify:code lang=\"ruby\">puts \"hi!\"</publify:code>")
        expect(result).to eq("lang=ruby (puts \"hi!\")")
      end

      it "parses contentful tags with single-quoted attribute values" do
        result = described_class
          .filtertext("<publify:code lang='ruby'>puts \"hi!\"</publify:code>")
        expect(result).to eq("lang=ruby (puts \"hi!\")")
      end
    end
  end

  describe described_class::MacroPre do
    it_behaves_like "an abstract macro class"

    it "declares itself to be a macropre filter" do
      expect(described_class.filter_type).to eq "macropre"
    end
  end

  describe described_class::MacroPost do
    it_behaves_like "an abstract macro class"

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
