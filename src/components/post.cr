class Post::Post < BaseComponent
  needs response : PostResponse::Root

  def render
    data = response.data.post.content.bodyModel.paragraphs
    data.each do |paragraph|
      case paragraph.type
      when PostResponse::ParagraphType::H3
        h3 paragraph.text
      when PostResponse::ParagraphType::H4
        h4 paragraph.text
      when PostResponse::ParagraphType::P
        para paragraph.text
      when PostResponse::ParagraphType::PRE
        pre paragraph.text
      when PostResponse::ParagraphType::BQ
        blockquote paragraph.text
      when PostResponse::ParagraphType::OLI
        li paragraph.text
      when PostResponse::ParagraphType::ULI
        li paragraph.text
      when PostResponse::ParagraphType::IFRAME
        mount IFrame, paragraph: paragraph
      else
        para "#{paragraph.type} not yet implimented"
      end
    end
  end
end
