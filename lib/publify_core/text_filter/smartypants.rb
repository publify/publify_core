# frozen_string_literal: true

require "rubypants"

module PublifyCore::TextFilter
  class Smartypants < TextFilterPlugin::PostProcess
    plugin_display_name "Smartypants"
    plugin_description "Converts HTML to use typographically correct quotes and dashes"

    def self.filtertext(text)
      RubyPants.new(text).to_html
    end
  end
end
