# frozen_string_literal: true

# FIXME: Replace with helpers and/or methods provided by Rails
module PublifyCore
  module StringExt
    def to_permalink
      PublifyCore::TextTransformer.to_permalink(self)
    end

    # Returns a-string-with-dashes when passed 'a string with dashes'.
    # All special chars are stripped in the process
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

deprecator = ActiveSupport::Deprecation.new("10.1", "PublifyCore")
deprecator.deprecate_methods PublifyCore::StringExt, :to_permalink
