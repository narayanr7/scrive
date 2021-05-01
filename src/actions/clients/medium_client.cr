require "json"

class MediumClient
  # https://stackoverflow.com/questions/2669690/
  JSON_HIJACK_STRING = "])}while(1);</x>"

  def self.post_data(post_id : String) : HTTP::Client::Response
    client = HTTP::Client.new("medium.com", tls: true)
    client.post("/_/graphql", headers: headers, body: body(post_id))
  end

  def self.embed_data(media_id : String) : MediaResponse::Root
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

class MediaResponse
  class Base
    include JSON::Serializable
  end

  class Root < Base
    property payload : Payload
  end

  class Payload < Base
    property value : Value
  end

  class Value < Base
    property href : String
    property iframeSrc : String
  end
end
