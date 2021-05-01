abstract class MainLayout
  include Lucky::HTMLPage

  abstract def content
  abstract def page_title

  def page_title
    "Welcome"
  end

  def render
    html_doctype

    html lang: "en" do
      mount Shared::LayoutHead, page_title: page_title, context: context

      body do
        mount Shared::FlashMessages, context.flash
        content
      end
    end
  end
end
