require "json"

class Articles::Show < BrowserAction
  fallback do
    maybe_post_id = post_id(context.request.path)
    case maybe_post_id
    in Monads::Just
      response = client_class.post_data(maybe_post_id.value!)
      page = PageConverter.new.convert(response.data)
      html ShowPage, page: page
    in Monads::Nothing, Monads::Maybe
      html(
        Errors::ShowPage,
        message: "Error parsing the URL",
        status: 500,
      )
    end
  end

  def post_id(request_path : String)
    Monads::Try(Regex::MatchData)
      .new(->{ request_path.match(/([0-9a-f]+)$/i) })
      .to_maybe
      .fmap(->(matches : Regex::MatchData) { matches[1] })
  end

  def client_class
    if Lucky::Env.use_local?
      LocalClient
    else
      MediumClient
    end
  end
end
