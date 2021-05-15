class Articles::ShowPage < MainLayout
  needs post_response : PostResponse::Root

  def content
    mount Post::Post, response: post_response
  end
end
