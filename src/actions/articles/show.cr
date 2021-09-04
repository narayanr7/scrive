require "json"

class Articles::Show < BrowserAction
  get "/posts/:post_id" do
    if Lucky::Env.use_local?
      response = LocalClient.post_data(post_id)
    else
      response = MediumClient.post_data(post_id)
    end
    page = PageConverter.new.convert(response.data)
    html ShowPage, page: page
  end
end
