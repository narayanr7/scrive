struct HeaderData
  getter title : String
  getter subtitle : String?

  def initialize(@title : String, @subtitle : String?)
  end

  def first_content_paragraph_index : Int32
    if title.blank?
      0
    elsif subtitle.nil? || subtitle.blank?
      1
    else
      2
    end
  end
end

class PageConverter
  def convert(data : PostResponse::Data) : Page
    paragraphs = data.post.content.bodyModel.paragraphs
    author = data.post.creator
    created_at = Time.unix_ms(data.post.createdAt)
    header = header_data(paragraphs)
    if header.first_content_paragraph_index.zero?
      content = [] of PostResponse::Paragraph
    else
      content = paragraphs[header.first_content_paragraph_index..]
    end
    Page.new(
      title: header.title,
      subtitle: header.subtitle,
      author: author,
      created_at: Time.unix_ms(data.post.createdAt),
      nodes: ParagraphConverter.new.convert(content)
    )
  end

  def header_data(paragraphs : Array(PostResponse::Paragraph)) : HeaderData
    if paragraphs.empty?
      return HeaderData.new("", nil)
    end
    first_two_paragraphs = paragraphs.first(2)
    first_two_types = first_two_paragraphs.map(&.type)
    if first_two_types == [PostResponse::ParagraphType::H3, PostResponse::ParagraphType::H4]
      HeaderData.new(
        title: first_two_paragraphs[0].text,
        subtitle: first_two_paragraphs[1].text,
      )
    else
      HeaderData.new(
        title: first_two_paragraphs[0].text,
        subtitle: nil,
      )
    end
  end
end
