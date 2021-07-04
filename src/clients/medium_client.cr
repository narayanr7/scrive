require "json"

class MediumClient
  def self.post_data(post_id : String) : PostResponse::Root
    client = HTTP::Client.new("medium.com", tls: true)
    response = client.post("/_/graphql", headers: headers, body: body(post_id))
    PostResponse::Root.from_json(response.body)
  end

  def self.media_data(media_id : String) : MediaResponse::Root
    client = HTTP::Client.new("medium.com", tls: true)
    response = client.get("/media/#{media_id}", headers: headers)
    body = response.body.sub(JSON_HIJACK_STRING, nil)
    MediaResponse::Root.from_json(body)
  end

  private def self.headers : HTTP::Headers
    HTTP::Headers{
      "Accept"       => "application/json",
      "Content-Type" => "application/json; charset=utf-8",
    }
  end

  private def self.body(post_id : String) : String
    query = <<-GRAPHQL
      query {
        post(id: "#{post_id}") {
          title
          creator {
            id
            name
          }
          content {
            bodyModel {
              paragraphs {
                text
                type
                markups {
                  name
                  type
                  href
                  userId
                  start
                  end
                }
                href
                iframe {
                  mediaResource {
                    id
                  }
                }
                metadata {
                  __typename
                  id
                  originalWidth
                  originalHeight
                }
              }
            }
          }
        }
      }
    GRAPHQL
    JSON.build do |json|
      json.object do
        json.field "query", query
        json.field "variables", {} of String => String
      end
    end
  end
end
