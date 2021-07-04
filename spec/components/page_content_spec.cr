require "../spec_helper"

include Nodes

describe PageContent do
  it "renders a single parent/child node structure" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        Text.new(content: "hi"),
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>hi</p>)
  end

  it "renders multiple childrens" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        Text.new(content: "Hello, "),
        Emphasis.new(children: [
          Text.new(content: "World!")
        ] of Child)
      ] of Child),
      UnorderedList.new(children: [
        ListItem.new(children: [
          Text.new(content: "List!")
        ] of Child),
        ListItem.new(children: [
          Text.new(content: "Again!"),
        ] of Child)
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>Hello, <em>World!</em></p><ul><li>List!</li><li>Again!</li></ul>)
  end

  it "renders an anchor" do
    page = Page.new(nodes: [
      Anchor.new(href: "https://example.com", text: "link"),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<a href="https://example.com">link</a>)
  end

  it "renders a blockquote" do
    page = Page.new(nodes: [
      BlockQuote.new(children: [
        Text.new("Wayne Gretzky. Michael Scott.")
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<blockquote>Wayne Gretzky. Michael Scott.</blockquote>)
  end

  it "renders code" do
    page = Page.new(nodes: [
      Code.new(children: [
        Text.new("foo = bar")
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<code>foo = bar</code>)
  end

  it "renders empasis" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        Text.new(content: "This is "),
        Emphasis.new(children: [
          Text.new(content: "neat!")
        ] of Child),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>This is <em>neat!</em></p>)
  end

  it "renders an H3" do
    page = Page.new(nodes: [
      Heading3.new(children: [
        Text.new(content: "Title!"),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<h3>Title!</h3>)
  end

  it "renders an H4" do
    page = Page.new(nodes: [
      Heading4.new(children: [
        Text.new(content: "In Conclusion..."),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<h4>In Conclusion...</h4>)
  end

  it "renders an image" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        Image.new(src: "image.png"),
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p><img src="https://cdn-images-1.medium.com/image.png"></p>)
  end

  it "renders an iframe container" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        IFrame.new(href: "https://example.com"),
      ] of Child)
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p><div class="embedded"><a href="https://example.com">Click to visit embedded content</a></div></p>)
  end

  it "renders an ordered list" do
    page = Page.new(nodes: [
      OrderedList.new(children: [
        ListItem.new(children: [Text.new("One")] of Child),
        ListItem.new(children: [Text.new("Two")] of Child),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<ol><li>One</li><li>Two</li></ol>)
  end

  it "renders an preformatted text" do
    page = Page.new(nodes: [
      Paragraph.new(children: [
        Text.new("Hello, world!"),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<p>Hello, world!</p>)
  end

  it "renders an preformatted text" do
    page = Page.new(nodes: [
      Preformatted.new(children: [
        Text.new("New\nline"),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<pre>New\nline</pre>)
  end

  it "renders strong text" do
    page = Page.new(nodes: [
      Strong.new(children: [
        Text.new("Oh yeah!"),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<strong>Oh yeah!</strong>)
  end

  it "renders an unordered list" do
    page = Page.new(nodes: [
      UnorderedList.new(children: [
        ListItem.new(children: [Text.new("Apple")] of Child),
        ListItem.new(children: [Text.new("Banana")] of Child),
      ] of Child),
    ] of Child)

    html = PageContent.new(page: page).render_to_string

    html.should eq %(<ul><li>Apple</li><li>Banana</li></ul>)
  end
end
