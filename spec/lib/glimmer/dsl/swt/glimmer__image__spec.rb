require "spec_helper"

module GlimmerSpec
  describe "Glimmer Image" do
    include Glimmer

    it "builds image with file path" do
      @target = @image = image(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
      
      expect(@target.bounds.width).to eq(132)
      expect(@target.bounds.height).to eq(40)
    end

  end
  
end
