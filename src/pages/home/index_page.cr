class Home::IndexPage < MainLayout
  def page_title
    "Scribe"
  end

  def content
    h1 "Scribe"
    article do
      section do
        h2 "How-To"
        para do
          text "To view a Medium post simply replace "
          code "medium.com", class: "highlight"
          text " with "
          code app_domain, class: "highlight"
        end
        para do
          text "For example if the URL is: "
          code do
            span "medium.com", class: "highlight"
            text "/@user/my-post-09a6af907a2"
          end
          text " change it to "
          code do
            span app_domain, class: "highlight"
            text "/@user/my-post-09a6af907a2"
          end
        end
      end
      section do
        footer do
          para do
            a "Source code", href: "https://git.sr.ht/~edwardloveall/scribe"
          end
        end
      end
    end
  end

  def app_domain
    URI.parse(Home::Index.url).normalize
      .to_s
      .sub(/\/$/, "")
      .sub(/^https?:\/\//, "")
  end
end
