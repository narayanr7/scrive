class Home::IndexPage < MainLayout
  def page_title
    "Scribe"
  end

  def content
    post_id = "92f4e0bb9f53"
    post_slug = "my-post-#{post_id}"
    h1 "Scribe"
    h2 "How-To"
    article do
      section do
        para "To view a medium post, you need the last part of the post's URL."
        para do
          text "For example if the URL is: "
          code "medium.com/@user/#{post_slug}"
          text " or "
          code "user.medium.com/#{post_slug}"
          text " or "
          code "somewebsite.com/blog/#{post_slug}"
        end
        para do
          text " take "
          code post_slug
          text " and add it on to the end of Scribe's post URL: "
        end
        para do
          code Articles::Show.with(post_slug: post_slug).url
        end
      end
      section do
        para do
          text "Hint: If you're feeling lazy, the URL only needs to be the nonsense at the end of the post URL. E.g. "
          code Articles::Show.with(post_slug: post_id).url
        end
      end
    end
  end
end
