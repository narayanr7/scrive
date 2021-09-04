class Articles::ShowPage < MainLayout
  needs page : Page

  def page_title
    page.title
  end

  def content
    h1 page.title
    if subtitle = page.subtitle
      para subtitle, class: "subtitle"
    end
    article do
      section do
        mount PageContent, page: page
      end
    end
  end
end
