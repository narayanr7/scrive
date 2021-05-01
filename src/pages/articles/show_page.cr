class Articles::ShowPage < MainLayout
  needs medium_response_body : PostResponse::Root

  def content
    paragraphs = medium_response_body.data.post.content.bodyModel.paragraphs
    paragraphs.each do |paragraph|
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
        embed = paragraph.iframe
        if embed
          embed_data = LocalClient.embed_data(embed.mediaResource.id)
          embed_value = embed_data.payload.value
          if embed_value.iframeSrc.blank?
            iframe src: embed_data.payload.value.href
          else
            iframe src: embed_data.payload.value.iframeSrc
          end
        end
      else
        para "#{paragraph.type} not yet implimented"
      end
    end
  end
end
