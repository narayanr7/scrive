require "json"

class Articles::Show < BrowserAction
  get "/post/:post_id" do
    if Lucky::Env.use_local?
      response = LocalClient.post_data(post_id)
    else
      response = MediumClient.post_data(post_id)
    end
    html ShowPage, post_response: response
  end
end
