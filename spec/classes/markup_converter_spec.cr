require "../spec_helper"

include Nodes

describe MarkupConverter do
  it "returns just text with no markups" do
    json = <<-JSON
      {
        "text": "Hello, world",
        "type": "P",
        "markups": [],
        "href": null,
        "iframe": null,
        "layout": null,
        "metadata": null
      }
    JSON
    paragraph = PostResponse::Paragraph.from_json(json)

    result = MarkupConverter.convert(text: paragraph.text, markups: paragraph.markups)

    result.should eq([Text.new(content: "Hello, world")])
  end

  it "returns just text with multiple markups" do
    json = <<-JSON
      {
        "text": "strong and emphasized only",
        "type": "P",
        "markups": [
          {
            "title": null,
            "type": "STRONG",
            "href": null,
            "start": 0,
            "end": 6,
            "rel": null,
            "anchorType": null
          },
          {
            "title": null,
            "type": "EM",
            "href": null,
            "start": 11,
            "end": 21,
            "rel": null,
            "anchorType": null
          }
        ],
        "href": null,
        "iframe": null,
        "layout": null,
        "metadata": null
      }
    JSON
    paragraph = PostResponse::Paragraph.from_json(json)

    result = MarkupConverter.convert(text: paragraph.text, markups: paragraph.markups)

    result.should eq([
      Strong.new(children: [Text.new(content: "strong")] of Child),
      Text.new(content: " and "),
      Emphasis.new(children: [Text.new(content: "emphasized")] of Child),
      Text.new(content: " only"),
    ])
  end

  it "returns just text with a code markup" do
    json = <<-JSON
      {
        "text": "inline code",
        "type": "P",
        "markups": [
          {
            "title": null,
            "type": "CODE",
            "href": null,
            "start": 7,
            "end": 11,
            "rel": null,
            "anchorType": null
          }
        ],
        "href": null,
        "iframe": null,
        "layout": null,
        "metadata": null
      }
    JSON
    paragraph = PostResponse::Paragraph.from_json(json)

    result = MarkupConverter.convert(text: paragraph.text, markups: paragraph.markups)

    result.should eq([
      Text.new(content: "inline "),
      Code.new(children: [Text.new(content: "code")] of Child),
    ])
  end

  it "renders an A LINK markup" do
    json = <<-JSON
      {
        "text": "I am a Link",
        "type": "P",
        "markups": [
          {
            "title": "",
            "type": "A",
            "href": "https://example.com",
            "start": 7,
            "end": 11,
            "rel": "",
            "anchorType": "LINK"
          }
        ],
        "href": null,
        "iframe": null,
        "layout": null,
        "metadata": null
      }
    JSON

    paragraph = PostResponse::Paragraph.from_json(json)

    result = MarkupConverter.convert(text: paragraph.text, markups: paragraph.markups)

    result.should eq([
      Text.new("I am a "),
      Anchor.new(text: "Link", href: "https://example.com"),
    ])
  end

  it "renders an A USER markup" do
    json = <<-JSON
      {
        "text": "Hi Dr Nick!",
        "type": "P",
        "markups": [
          {
            "title": null,
            "type": "A",
            "href": null,
            "userId": "abc123",
            "start": 3,
            "end": 10,
            "rel": null,
            "anchorType": "USER"
          }
        ],
        "href": null,
        "iframe": null,
        "layout": null,
        "metadata": null
      }
    JSON

    paragraph = PostResponse::Paragraph.from_json(json)

    result = MarkupConverter.convert(text: paragraph.text, markups: paragraph.markups)

    result.should eq([
      Text.new("Hi "),
      UserAnchor.new(text: "Dr Nick", userId: "abc123"),
      Text.new("!"),
    ])
  end
end
