require "../spec_helper"

include Nodes

describe IFrameMediaResolver do
  around_each do |example|
    original_client = IFrameMediaResolver.http_client
    IFrameMediaResolver.http_client = FakeMediumClient
    example.run
    IFrameMediaResolver.http_client = original_client
  end

  it "returns a url of the embedded page" do
    iframe = PostResponse::IFrame.from_json <<-JSON
      {
        "mediaResource": {
          "id": "d4515fff7ecd02786e75fc8997c94bbf"
        }
      }
    JSON
    resolver = IFrameMediaResolver.new(iframe: iframe)

    result = resolver.fetch_href

    result.should eq("https://example.com")
  end
end
