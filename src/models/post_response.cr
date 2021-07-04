class PostResponse
  class Base
    include JSON::Serializable
  end

  class Root < Base
    property data : Data
  end

  class Data < Base
    property post : Post
  end

  class Post < Base
    property title : String
    property creator : Creator
    property content : Content
  end

  class Creator < Base
    property name : String
    property id : String
  end

  class Content < Base
    property bodyModel : BodyModel
  end

  class BodyModel < Base
    property paragraphs : Array(Paragraph)
  end

  class Paragraph < Base
    property text : String
    property type : ParagraphType
    property markups : Array(Markup)
    property iframe : IFrame?
    property layout : String?
    property metadata : Metadata?
  end

  enum ParagraphType
    BQ
    H3
    H4
    IFRAME
    IMG
    OLI
    P
    PRE
    ULI
  end

  class Markup < Base
    property title : String?
    property type : MarkupType
    property href : String?
    property userId : String?
    property start : Int32
    property end : Int32
    property anchorType : AnchorType?
  end

  enum MarkupType
    A
    CODE
    EM
    STRONG
  end

  enum AnchorType
    LINK
    USER
  end

  class IFrame < Base
    property mediaResource : MediaResource
  end

  class MediaResource < Base
    property id : String
  end

  class Metadata < Base
    property id : String
    property originalWidth : Int32
    property originalHeight : Int32
  end
end
