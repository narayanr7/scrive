require "../spec_helper"

include Nodes

describe PageConverter do
  it "sets the title and subtitle if present" do
    paragraph_json = <<-JSON
      [
        {
          "text": "Title",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Subtitle",
          "type": "H4",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    data_json = default_data_json(paragraph_json)
    data = PostResponse::Data.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.title.should eq "Title"
    page.subtitle.should eq "Subtitle"
  end

  it "sets the title to the first paragraph if no title" do
    paragraph_json = <<-JSON
      [
        {
          "text": "Not a title",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    data_json = default_data_json(paragraph_json)
    data = PostResponse::Data.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.title.should eq "Not a title"
    page.subtitle.should eq nil
  end

  it "sets the author" do
    data_json = <<-JSON
      {
        "post": {
          "title": "This is a story",
          "createdAt": 0,
          "creator": {
            "id": "abc123",
            "name": "Author"
          },
          "content": {
            "bodyModel": {
              "paragraphs": []
            }
          }
        }
      }
    JSON
    data = PostResponse::Data.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.author.should eq "Author"
  end

  it "sets the publish date/time" do
    data_json = <<-JSON
      {
        "post": {
          "title": "This is a story",
          "createdAt": 1000,
          "creator": {
            "id": "abc123",
            "name": "Author"
          },
          "content": {
            "bodyModel": {
              "paragraphs": []
            }
          }
        }
      }
    JSON
    data = PostResponse::Data.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.created_at.should eq Time.utc(1970, 1, 1, 0, 0, 1)
  end

  it "calls ParagraphConverter to convert the remaining paragraph content" do
    paragraph_json = <<-JSON
      [
        {
          "text": "Title",
          "type": "H3",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Subtitle",
          "type": "H4",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Content",
          "type": "P",
          "markups": [],
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    data_json = default_data_json(paragraph_json)
    data = PostResponse::Data.from_json(data_json)

    page = PageConverter.new.convert(data)

    page.nodes.should eq [
      Paragraph.new([
        Text.new("Content"),
      ] of Child),
    ]
  end
end

def default_data_json(paragraph_json : String)
  <<-JSON
    {
      "post": {
        "title": "This is a story",
        "createdAt": 1628974309758,
        "creator": {
          "id": "abc123",
          "name": "Author"
        },
        "content": {
          "bodyModel": {
            "paragraphs": #{paragraph_json}
          }
        }
      }
    }
  JSON
end
