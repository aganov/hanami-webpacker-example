# frozen_string_literal: true

module Web
  module Views
    module HeadElementsHelper
      private

      def favicon_link_tag
        html.link(rel: "icon", type: "image/x-icon", href: asset_pack_path("images/favicon.ico"))
      end

      def stylesheet_link_tag(*sources)
        options = sources.extract_options!.symbolize_keys
        safe_tags(*sources) do |source|
          html.link({ rel: "stylesheet", media: "screen", href: source }.merge(options)).to_s
        end
      end

      def javascript_include_tag(*sources)
        options = sources.extract_options!.symbolize_keys
        safe_tags(*sources) do |source|
          html.script({ src: source }.merge(options)).to_s
        end
      end

      def safe_tags(*sources)
        raw(
          sources.map { |source| yield source }.join("\n")
        )
      end
    end
  end
end
