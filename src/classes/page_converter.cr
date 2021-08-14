class PageConverter
  def convert(paragraphs : Array(PostResponse::Paragraph)) : Page
    first_two_paragraphs = paragraphs.first(2)
    first_two_types = first_two_paragraphs.map(&.type)
    if first_two_types == [PostResponse::ParagraphType::H3, PostResponse::ParagraphType::H4]
      Page.new(
        title: first_two_paragraphs[0].text,
        subtitle: first_two_paragraphs[1].text,
        nodes: ParagraphConverter.new.convert(paragraphs[2..]),
      )
    else
      Page.new(
        title: first_two_paragraphs[0].text,
        subtitle: nil,
        nodes: ParagraphConverter.new.convert(paragraphs[1..]),
      )
    end
  end
end
