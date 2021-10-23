class Shared::LayoutFooter < BaseComponent
  def render
    section do
      footer do
        para do
          a "Source code", href: "https://sr.ht/~edwardloveall/scribe"
        end
      end
    end
  end
end
