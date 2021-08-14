class PageContent < BaseComponent
  include Nodes
  needs page : Page

  def render
    page.nodes.each do |node|
      render_child(node)
    end
  end

  def render_children(children : Children)
    children.each { |child| render_child(child) }
  end

  def render_child(node : Anchor)
    a(href: node.href) { render_children(node.children) }
  end

  def render_child(node : BlockQuote)
    blockquote { render_children(node.children) }
  end

  def render_child(node : Code)
    code { render_children(node.children) }
  end

  def render_child(container : Container)
    # Should never get called
    raw "<!-- a Container was rendered -->"
  end

  def render_child(node : Emphasis)
    em { render_children(node.children) }
  end

  def render_child(container : Empty)
    # Should never get called
    raw "<!-- an Empty was rendered -->"
  end

  def render_child(node : Figure)
    figure { render_children(node.children) }
  end

  def render_child(node : FigureCaption)
    figcaption { render_children(node.children) }
  end

  def render_child(node : Heading3)
    h3 { render_children(node.children) }
  end

  def render_child(node : Heading4)
    h4 { render_children(node.children) }
  end

  def render_child(child : IFrame)
    div class: "embedded" do
      a href: child.href do
        text "Embedded content at #{child.domain}"
      end
    end
  end

  def render_child(child : Image)
    img src: child.src, width: child.width
  end

  def render_child(node : ListItem)
    li { render_children(node.children) }
  end

  def render_child(node : OrderedList)
    ol { render_children(node.children) }
  end

  def render_child(node : Paragraph)
    para { render_children(node.children) }
  end

  def render_child(node : Preformatted)
    pre { render_children(node.children) }
  end

  def render_child(node : Strong)
    strong { render_children(node.children) }
  end

  def render_child(child : Text)
    text child.content
  end

  def render_child(node : UnorderedList)
    ul { render_children(node.children) }
  end

  def render_child(node : UserAnchor)
    a(href: node.href) { render_children(node.children) }
  end
end
