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

  shared_examples "a macro module" do
    describe ".attributes_parse" do
      it 'parses lang="ruby" to {"lang" => "ruby"}' do
        expect(derived_class.attributes_parse('<publify:code lang="ruby">'))
          .to eq("lang" => "ruby")
      end

      it "parses lang='ruby' to {'lang' => 'ruby'}" do
        expect(derived_class.attributes_parse("<publify:code lang='ruby'>"))
          .to eq("lang" => "ruby")
      end
    end
  end

  describe described_class::MacroPre, "when included" do
    let(:derived_class) do
      Class.new.tap { |klass| klass.include described_class }
    end

    it_behaves_like "a macro module"

    it "declares including classes to be macropre filters" do
      expect(derived_class.filter_type).to eq "macropre"
    end
  end

  describe described_class::MacroPost, "when included" do
    let(:derived_class) do
      Class.new.tap { |klass| klass.include described_class }
    end

    it_behaves_like "a macro module"

    it "declares including classes to be macropost filters" do
      expect(derived_class.filter_type).to eq "macropost"
    end
  end

  describe described_class::Markup, "when included" do
    let(:derived_class) do
      Class.new.tap { |klass| klass.include described_class }
    end

    it "declares including classes to be markup filters" do
      expect(derived_class.filter_type).to eq "markup"
    end
  end
end
