require "spec_helper"

module GlimmerSpec
  describe "Glimmer Image" do
    include Glimmer

    it "builds ImageProxy with file path" do
      @target = @image = image(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
      
      expect(@target.bounds.width).to eq(132)
      expect(@target.bounds.height).to eq(40)
    end
    
    it 'builds ImageProxy with image' do
      swt_image = Image.new(display.swt_display, File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
      @target = @image = image(swt_image)
      
      expect(@target.bounds.width).to eq(132)
      expect(@target.bounds.height).to eq(40)
    end
    
    it 'builds ImageProxy with swt_image option' do
      swt_image = Image.new(display.swt_display, File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
      @target = @image = image(swt_image: swt_image)
      
      expect(@target.bounds.width).to eq(132)
      expect(@target.bounds.height).to eq(40)
    end
    
    it 'builds ImageProxy with array of args' do
      @target = @image = image(display.swt_display, File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
      
      expect(@target.bounds.width).to eq(132)
      expect(@target.bounds.height).to eq(40)
    end
  end
  
end
