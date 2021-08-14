require "../spec_helper"

include Nodes

describe PageConverter do
  it "sets the title and subtitle if present" do
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
        },
        {
          "text": "Subtitle",
          "type": "H4",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON

    page = PageConverter.new.convert(paragraphs)

    page.title.should eq "Title"
    page.subtitle.should eq "Subtitle"
  end

  it "sets the title to the first paragraph if no title" do
    paragraphs = Array(PostResponse::Paragraph).from_json <<-JSON
      [
        {
          "text": "Not a title",
          "type": "P",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON
    page = PageConverter.new.convert(paragraphs)

    page.title.should eq "Not a title"
    page.subtitle.should eq nil
  end

  it "calls ParagraphConverter to convert the remaining paragraph content" do
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
        },
        {
          "text": "Subtitle",
          "type": "H4",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        },
        {
          "text": "Content",
          "type": "P",
          "markups": [],
          "href": null,
          "iframe": null,
          "layout": null,
          "metadata": null
        }
      ]
    JSON

    page = PageConverter.new.convert(paragraphs)

    page.nodes.should eq [
      Paragraph.new([
        Text.new("Content"),
      ] of Child),
    ]
  end
end
