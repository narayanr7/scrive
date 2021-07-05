require "../spec_helper"

module Nodes
  describe Image do
    it "adjusts the width and height proportionally" do
      image = Image.new(src: "image.png", originalWidth: 1000, originalHeight: 603)

      image.width.should eq("800")
      image.height.should eq("482")
    end

    it "includes the adjusted width and height in the src" do
      image = Image.new(src: "image.png", originalWidth: 1000, originalHeight: 603)

      image.src.should eq("https://cdn-images-1.medium.com/fit/c/800/482/image.png")
    end
  end
end
