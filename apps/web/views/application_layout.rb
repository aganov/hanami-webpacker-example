module Web
  module Views
    class ApplicationLayout
      include Web::Layout
      include Web::Views::HeadElementsHelper
      include Webpacker::Helper
    end
  end
end
