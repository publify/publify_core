# frozen_string_literal: true

require "rails_helper"

RSpec.describe PublifyCore::TextFilter::Markdown do
  def filter_text(text)
    described_class.filtertext(text)
  end

  it "applies markdown processing to the supplied text" do
    text = filter_text("*foo*")
    expect(text).to eq "<p><em>foo</em></p>"

    text = filter_text("foo\n\nbar")
    expect(text).to eq "<p>foo</p>\n<p>bar</p>"
  end

  it "does not apply smart quoting to the supplied text" do
    text = filter_text("'foo'")
    expect(text).to eq "<p>'foo'</p>"
  end

  it "passes through publify macros" do
    result = described_class.filtertext("foo <publify:foo>Hello!</publify:foo>")

    expect(result).to eq "<p>foo <publify:foo>Hello!</publify:foo></p>"
  end
end
