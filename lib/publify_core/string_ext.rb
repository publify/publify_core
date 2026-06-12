# frozen_string_literal: true

# FIXME: Replace with helpers and/or methods provided by Rails
module PublifyCore
  module StringExt
    ACCENTS = { %w(á à â ä ã Ã Ä Â À) => "a",
                %w(é è ê ë Ë É È Ê) => "e",
                %w(í ì î ï I Î Ì) => "i",
                %w(ó ò ô ö õ Õ Ö Ô Ò) => "o",
                ["œ"] => "oe",
                ["ß"] => "ss",
                %w(ú ù û ü U Û Ù) => "u",
                %w(ç Ç) => "c" }.freeze

    def to_permalink
      string = self
      ACCENTS.each do |key, value|
        string = string.tr(key.join, value)
      end
      string = string.tr("'", "-")
      string.gsub(/<[^>]*>/, "").to_url
    end

    def to_title(item, settings, params)
      TitleBuilder.new(self).build(item, settings, params)
    end

    protected

    # Returns a-string-with-dashes when passed 'a string with dashes'.
    # All special chars are stripped in the process
    def to_url
      return if nil?

      s = downcase.tr("\"'", "")
      s = s.gsub(/\P{Word}/, " ")
      s.strip.tr_s(" ", "-").tr(" ", "-").sub(/^$/, "-")
    end
  end
end

String.include PublifyCore::StringExt
