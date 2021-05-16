class IFrameMediaResolver
  class_property http_client : MediumClient.class = MediumClient

  getter iframe

  def initialize(@iframe : PostResponse::IFrame)
  end

  def fetch_href
    response = @@http_client.media_data(iframe.mediaResource.id)
    response.payload.value.href
  end
end
