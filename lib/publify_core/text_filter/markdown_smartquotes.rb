# frozen_string_literal: true

require "text_filter_plugin"
require "publify_core/text_filter/markdown"

module PublifyCore::TextFilter
  class MarkdownSmartquotes < PublifyCore::TextFilter::Markdown
    plugin_display_name "Markdown with smart quotes"
    plugin_description "Markdown markup language from" \
                       ' <a href="http://daringfireball.com/">Daring Fireball</a>' \
                       " with automatic use of typographically correct quotes and dashes"

    def self.filtertext(text)
      # FIXME: Workaround for <publify:foo> not being interpreted as an HTML tag.
      escaped_macros = text.gsub(%r{(</?publify):}, '\1X')
      html = Commonmarker.to_html(escaped_macros, options: {
                                    parse: { smart: true },
                                    render: { unsafe: true }
                                  })
      html.gsub(%r{(</?publify)X}, '\1:').strip
    end
  end
end
