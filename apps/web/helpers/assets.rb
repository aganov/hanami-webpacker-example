# frozen_string_literal: true

module Web
  module Helpers
    module Assets
      ASSET_EXTENSIONS = { javascript: ".js", stylesheet: ".css" }
      URI_REGEXP = %r{^[-a-z]+://|^(?:cid|data):|^//}i

      def asset_path(source, options = {})
        raise ArgumentError, "nil is not a valid asset source" if source.nil?

        source = source.to_s
        return "" if source.blank?
        return source if URI_REGEXP.match?(source)

        tail, source = source[/([\?#].+)$/], source.sub(/([\?#].+)$/, "".freeze)

        if extname = compute_asset_extname(source, options)
          source = "#{source}#{extname}"
        end

        raw("#{source}#{tail}")
      end

      alias_method :asset_url, :asset_path

      def compute_asset_extname(source, options = {})
        return if options[:extname] == false
        extname = options[:extname] || ASSET_EXTENSIONS[options[:type]]
        extname if extname && File.extname(source) != extname
      end
    end
  end
end
