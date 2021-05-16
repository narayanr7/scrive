class Articles::ShowPage < MainLayout
  needs page : Page

  def content
    mount PageContent, page: page
  end
end
