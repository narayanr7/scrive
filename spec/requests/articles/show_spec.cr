require "../../spec_helper"

class TestClient < MediumClient
  class_property last_post_id : String = ""

  def self.post_data(post_id : String) : PostResponse::Root
    self.last_post_id = post_id
    PostResponse::Root.from_json <<-JSON
      {
        "data": {
          "post": {
            "title": "a title",
            "createdAt": 0,
            "creator": { "id": "0", "name": "username" },
            "content": { "bodyModel": { "paragraphs": [] } }
          }
        }
      }
    JSON
  end
end

class Articles::Show
  def client_class
    TestClient
  end
end

describe Articles::Show do
  it "parses the post id for urls like /@user/:post_slug" do
    HttpClient.get("/@user/my-post-111111abcdef")

    TestClient.last_post_id.should eq("111111abcdef")
  end

  it "parses the post id for urls like /user/:post_slug" do
    HttpClient.get("/user/my-post-222222abcdef")

    TestClient.last_post_id.should eq("222222abcdef")
  end

  it "parses the post id for urls like /p/:post_slug" do
    HttpClient.get("/p/my-post-333333abcdef")

    TestClient.last_post_id.should eq("333333abcdef")
  end

  it "parses the post id for urls like /posts/:post_slug" do
    HttpClient.get("/posts/my-post-444444abcdef")

    TestClient.last_post_id.should eq("444444abcdef")
  end

  it "parses the post id for urls like /p/:post_id" do
    HttpClient.get("/p/555555abcdef")

    TestClient.last_post_id.should eq("555555abcdef")
  end

  it "parses the post id for urls like /:post_slug" do
    HttpClient.get("/my-post-666666abcdef")

    TestClient.last_post_id.should eq("666666abcdef")
  end

  it "parses the post id for urls like /https:/medium.com/@user/:post_slug" do
    HttpClient.get("/https:/medium.com/@user/777777abcdef")

    TestClient.last_post_id.should eq("777777abcdef")
  end
end
