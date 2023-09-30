# frozen_string_literal: true

require "text_filter_plugin"

module PublifyCore::TextFilter
  class None < TextFilterPlugin
    include TextFilterPlugin::Markup

    plugin_display_name "None"
    plugin_description "Raw HTML only"

    def self.filtertext(text)
      text
    end
  end
end
