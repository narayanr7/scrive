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
    para do
      text "#{page.author} #{created_at(page.created_at)}"
    end
    article do
      section do
        mount PageContent, page: page
      end
    end
  end

  def created_at(time : Time) : String
    "at #{time.to_s("%I:%M%p")} on #{time.to_s("%F")}"
  end
end
