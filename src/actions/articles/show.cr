require "json"

class Articles::Show < BrowserAction
  get "/posts/:post_slug" do
    id_match = post_slug.match(/([0-9a-f]{12})$/i)
    if id_match
      post_id = id_match[1]
    else
      return html(
        Errors::ShowPage,
        message: "Error parsing the URL",
        status: 500,
      )
    end
    if Lucky::Env.use_local?
      response = LocalClient.post_data(post_id)
    else
      response = MediumClient.post_data(post_id)
    end
    page = PageConverter.new.convert(response.data)
    html ShowPage, page: page
  end
end
