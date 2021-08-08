module Nodes
  alias Leaf = Text | Image | IFrame | Anchor | UserAnchor
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

  class Figure < Container
  end

  class FigureCaption < Container
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
    IMAGE_HOST = "https://cdn-images-1.medium.com/fit/c"
    MAX_WIDTH  = 800

    getter originalHeight : Int32
    getter originalWidth : Int32

    def initialize(@src : String, @originalWidth : Int32, @originalHeight : Int32)
    end

    def ==(other : Image)
      other.src == src
    end

    def src
      [IMAGE_HOST, width, height, @src].join("/")
    end

    def width
      [originalWidth, MAX_WIDTH].min.to_s
    end

    def height
      if originalWidth > MAX_WIDTH
        (originalHeight * ratio).round.to_i.to_s
      else
        originalHeight.to_s
      end
    end

    private def ratio
      MAX_WIDTH / originalWidth
    end

    def empty?
      false
    end
  end

  class IFrame
    getter href : String

    def initialize(@href : String)
    end

    def domain
      URI.parse(href).host
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

  class UserAnchor
    USER_BASE_URL = "https://medium.com/u/"

    getter href : String
    getter text : String

    def initialize(userId : String, @text : String)
      @href = USER_BASE_URL + userId
    end

    def ==(other : UserAnchor)
      other.href == href && other.text == text
    end

    def empty?
      false
    end
  end
end
