class Page
  getter nodes : Nodes::Children
  getter title : String
  getter subtitle : String?
  getter author : String
  getter created_at : Time

  def initialize(
    @title : String,
    @subtitle : String?,
    @author : String,
    @created_at : Time,
    @nodes : Nodes::Children = [] of Nodes::Child
  )
  end
end
