module Nodes
  alias Leaf = Text | Image | IFrame | Anchor
  alias Child = Container | Leaf | Empty
  alias Children = Array(Child)

  class Container
    getter children : Children

    def initialize(@children : Children)
    end

    def ==(other : Container)
      other.children == children
    end

    def empty?
      children.empty? || children.each(&.empty?)
    end
  end

  class Empty
    def empty?
      true
    end
  end

  class BlockQuote < Container
  end

  class Code < Container
  end

  class Emphasis < Container
  end

  class Heading3 < Container
  end

  class Heading4 < Container
  end

  class ListItem < Container
  end

  class OrderedList < Container
  end

  class Paragraph < Container
  end

  class Preformatted < Container
  end

  class Strong < Container
  end

  class UnorderedList < Container
  end

  class Text
    getter content : String

    def initialize(@content : String)
    end

    def ==(other : Text)
      other.content == content
    end

    def empty?
      content.empty?
    end
  end

  class Image
    IMAGE_HOST = "https://cdn-images-1.medium.com"

    getter src : String

    def initialize(src : String)
      @src = "#{IMAGE_HOST}/#{src}"
    end

    def ==(other : Image)
      other.src == src
    end

    def empty?
      false
    end
  end

  class IFrame
    getter href : String

    def initialize(@href : String)
    end

    def ==(other : IFrame)
      other.href == href
    end

    def empty?
      false
    end
  end

  class Anchor
    getter href : String
    getter text : String

    def initialize(@href : String, @text : String)
    end

    def ==(other : Anchor)
      other.href == href && other.text == text
    end

    def empty?
      false
    end
  end
end
