class Page
  getter nodes : Nodes::Children
  getter title : String
  getter subtitle : String?

  def initialize(
    @title : String,
    @subtitle : String?,
    @nodes : Nodes::Children = [] of Nodes::Child
  )
  end
end
