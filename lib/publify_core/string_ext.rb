# frozen_string_literal: true

# FIXME: Replace with helpers and/or methods provided by Rails
module PublifyCore
  module StringExt
    def to_permalink
      PublifyCore::TextTransformer.to_permalink(self)
    end

    def to_url
      PublifyCore::TextTransformer.to_url(self)
    end

    def to_title(item, settings, params)
      TitleBuilder.new(self).build(item, settings, params)
    end

    def strip_html
      PublifyCore::TextTransformer.strip_html(self)
    end
  end
end

String.include PublifyCore::StringExt
