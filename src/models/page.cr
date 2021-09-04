class Page
  getter nodes : Nodes::Children
  getter title : String
  getter subtitle : String?
  getter author : String

  def initialize(
    @title : String,
    @subtitle : String?,
    @author : String,
    @nodes : Nodes::Children = [] of Nodes::Child
  )
  end
end
