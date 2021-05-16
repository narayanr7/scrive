class FakeMediumClient < MediumClient
  def self.media_data(media_id : String) : MediaResponse::Root
    MediaResponse::Root.from_json(
      <<-JSON
        {"payload": {"value": {"href": "https://example.com"}}}
      JSON
    )
  end
end
