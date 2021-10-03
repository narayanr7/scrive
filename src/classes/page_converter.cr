class PageConverter
  def convert(data : PostResponse::Data) : Page
    title, content = title_and_content(data)
    author = data.post.creator
    created_at = Time.unix_ms(data.post.createdAt)
    Page.new(
      title: title,
      author: author,
      created_at: Time.unix_ms(data.post.createdAt),
      nodes: ParagraphConverter.new.convert(content)
    )
  end

  def title_and_content(data : PostResponse::Data) : {String, Array(PostResponse::Paragraph)}
    title = data.post.title
    paragraphs = data.post.content.bodyModel.paragraphs
    non_content_paragraphs = paragraphs.reject { |para| para.text == title }
    {title, non_content_paragraphs}
  end
end
