require "../spec_helper"

include Nodes

describe ParagraphConverter do
  around_each do |example|
    original_client = IFrameMediaResolver.http_client
    IFrameMediaResolver.http_client = FakeMediumClient
    example.run
    IFrameMediaResolver.http_client = original_client
  end

  it "converts a simple structure with no markups" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "Title",
          "type": "H3",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [Heading3.new(children: [Text.new(content: "Title")] of Child)]

    result = ParagraphConverter.new.convert(paragraphs)

    result.should eq expected
  end

  it "converts a simple structure with a markup" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "inline code",
          "type": "P",
          "markups": [
            {
              "name": null,
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
      ]
    JSON
    expected = [
      Paragraph.new(children: [
        Text.new(content: "inline "),
        Code.new(children: [Text.new(content: "code")] of Child),
      ] of Child)
    ]

    result = ParagraphConverter.new.convert(paragraphs)

    result.should eq expected
  end

  it "groups <ul> list items into one list" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "One",
          "type": "ULI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Two",
          "type": "ULI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Not a list item",
          "type": "P",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      UnorderedList.new(children: [
        ListItem.new(children: [Text.new(content: "One")] of Child),
        ListItem.new(children: [Text.new(content: "Two")] of Child),
      ] of Child),
      Paragraph.new(children: [Text.new(content: "Not a list item")] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs)

    result.should eq expected
  end

  it "groups <ol> list items into one list" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "One",
          "type": "OLI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Two",
          "type": "OLI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Not a list item",
          "type": "P",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      OrderedList.new(children: [
        ListItem.new(children: [Text.new(content: "One")] of Child),
        ListItem.new(children: [Text.new(content: "Two")] of Child),
      ] of Child),
      Paragraph.new(children: [Text.new(content: "Not a list item")] of Child),
    ]

    result = ParagraphConverter.new.convert(paragraphs)

    result.should eq expected
  end

  it "converts an IMG to a Figure" do
    paragraph = PostResponse::Paragraph.from_json <<-JSON
      {
        "text": "Image by someuser",
        "type": "IMG",
        "markups": [
          {
            "title": "",
            "type": "A",
            "href": "https://unsplash.com/@someuser",
            "userId": null,
            "start": 9,
            "end": 17,
            "rel": "photo-creator",
            "anchorType": "LINK"
          }
        ],
        "href": null,
        "iframe": null,
        "layout": "INSET_CENTER",
        "metadata": {
          "id": "image.png",
          "originalWidth": 618,
          "originalHeight": 682
        }
      }
    JSON
    expected = [
      Figure.new(children: [
        Image.new(src: "image.png"),
        FigureCaption.new(children: [
          Text.new("Image by "),
          Anchor.new(href: "https://unsplash.com/@someuser", text: "someuser"),
        ] of Child),
      ] of Child),
    ]

    result = ParagraphConverter.new.convert([paragraph])

    result.should eq expected
  end

  it "converts all the tags" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "text",
          "type": "H3",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "H4",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "P",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "PRE",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "BQ",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "ULI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "OLI",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "text",
          "type": "IMG",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": {
            "id": "1*miroimage.png",
            "originalWidth": 618,
            "originalHeight": 682
          }
        },
        {
          "text": "",
          "type": "IFRAME",
          "markups": [],
          "href": null,
          "iframe": {
            "mediaResource": {
              "id": "7c6231d165bf9fc1853f259a7b55bd14"
            }
          },
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    expected = [
      Heading3.new([Text.new("text")] of Child),
      Heading4.new([Text.new("text")] of Child),
      Paragraph.new([Text.new("text")] of Child),
      Preformatted.new([Text.new("text")] of Child),
      BlockQuote.new([Text.new("text")] of Child),
      UnorderedList.new([ListItem.new([Text.new("text")] of Child)] of Child),
      OrderedList.new([ListItem.new([Text.new("text")] of Child)] of Child),
      Figure.new(children: [
        Image.new(src: "1*miroimage.png"),
        FigureCaption.new(children: [Text.new("text")] of Child),
      ] of Child),
      IFrame.new(href: "https://example.com"),
    ]

    result = ParagraphConverter.new.convert(paragraphs)

    result.should eq expected
  end
end
