class EmbeddedConverter
  include Nodes

  GIST_HOST = "https://gist.github.com"

  getter paragraph : PostResponse::Paragraph

  def self.convert(paragraph : PostResponse::Paragraph) : Embedded | Empty
    new(paragraph).convert
  end

  def initialize(@paragraph : PostResponse::Paragraph)
  end

  def convert : Embedded | Empty
    Monads::Try(PostResponse::IFrame).new(->{ paragraph.iframe })
      .to_maybe
      .fmap(->(iframe : PostResponse::IFrame) { iframe.mediaResource })
      .fmap(->media_to_embedded(PostResponse::MediaResource))
      .value_or(Empty.new)
  end

  private def media_to_embedded(media : PostResponse::MediaResource) : Embedded
    if media.iframeSrc.blank?
      custom_embed(media)
    else
      EmbeddedContent.new(
        src: media.iframeSrc,
        originalWidth: media.iframeWidth,
        originalHeight: media.iframeHeight
      )
    end
  end

  private def custom_embed(media : PostResponse::MediaResource) : Embedded
    if media.href.starts_with?(GIST_HOST)
      GithubGist.new(href: media.href)
    else
      EmbeddedLink.new(href: media.href)
    end
  end
end
