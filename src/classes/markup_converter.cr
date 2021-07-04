struct StringSplit
  getter pre, content, post

  def initialize(@pre : String, @content : String, @post : String)
  end
end

class MarkupConverter
  include Nodes

  getter markups : Array(PostResponse::Markup)
  getter text : String

  def self.convert(text : String, markups : Array(PostResponse::Markup))
    new(text, markups).convert
  end

  def initialize(@text : String, @markups : Array(PostResponse::Markup))
  end

  def convert : Array(Child)
    if markups.empty?
      return [Text.new(content: text)] of Child
    end
    offset = 0
    text_splits = markups.reduce([text]) do |splits, markup|
      individual_split = split_string(markup.start - offset, markup.end - offset, splits.pop)
      offset = markup.end
      splits.push(individual_split.pre)
      splits.push(individual_split.content)
      splits.push(individual_split.post)
    end
    text_splits.in_groups_of(2, "").map_with_index do |split, index|
      plain, to_be_marked = split
      markup = markups.fetch(index, Text.new(""))
      if markup.is_a?(Text)
        [Text.new(plain)] of Child
      else
        case markup.type
        when PostResponse::MarkupType::A
          container = Anchor.new(href: markup.href || "#", text: to_be_marked)
        when PostResponse::MarkupType::CODE
          container = construct_markup(text: to_be_marked, container: Code)
        when PostResponse::MarkupType::EM
          container = construct_markup(text: to_be_marked, container: Emphasis)
        when PostResponse::MarkupType::STRONG
          container = construct_markup(text: to_be_marked, container: Strong)
        else
          container = construct_markup(text: to_be_marked, container: Code)
        end
        [Text.new(plain), container] of Child
      end
    end.flatten.reject(&.empty?)
  end

  private def construct_markup(text : String, container : Container.class) : Child
    container.new(children: [Text.new(content: text)] of Child)
  end

  private def split_string(start : Int32, finish : Int32, string : String)
    if start.zero?
      pre = ""
    else
      pre = string[0...start]
    end

    if finish == string.size
      post = ""
    else
      post = string[finish...string.size]
    end

    content = string[start...finish]
    StringSplit.new(pre, content, post)
  end
end
