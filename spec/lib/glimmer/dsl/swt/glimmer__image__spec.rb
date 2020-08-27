require "spec_helper"

module GlimmerSpec
  describe "Glimmer Image" do
    include Glimmer

    context 'as image' do
      it "builds image proxy and sets image via SWT Image" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        @target = shell {
          @label = label {
            image @image.swt_image
          }
        }
        
        expect(@image.bounds.width).to eq(132)
        expect(@image.bounds.height).to eq(40)
        expect(@label.swt_widget.getImage).to eq(@image.swt_image)
      end
  
      it "builds image proxy and sets image as ImageProxy" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        @target = shell {
          @label = label {
            image @image
          }
        }
        
        expect(@image.bounds.width).to eq(132)
        expect(@image.bounds.height).to eq(40)
        expect(@label.swt_widget.getImage).to eq(@image.swt_image)
      end
  
      it "sets background image as image path" do
        @target = shell {
          @label = label {
            image File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png')
          }
        }
        
        expect(@label.swt_widget.getImage.bounds.width).to eq(132)
        expect(@label.swt_widget.getImage.bounds.height).to eq(40)
      end
      
      it "builds and sets background image via image keyword" do
        @target = shell {
          @label = label {
            image img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
          }
        }
        
        expect(@label.swt_widget.getImage.bounds.width).to eq(132)
        expect(@label.swt_widget.getImage.bounds.height).to eq(40)
      end
    end

    context 'as background image' do
      it "builds image proxy and sets background image as SWT Image" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        @target = shell {
          background_image @image.swt_image
        }
        
        expect(@image.bounds.width).to eq(132)
        expect(@image.bounds.height).to eq(40)
        expect(@target.background_image).to eq(@image.swt_image)
      end
  
      it "builds image proxy and sets background image as ImageProxy" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        @target = shell {
          background_image @image
        }
        
        expect(@image.bounds.width).to eq(132)
        expect(@image.bounds.height).to eq(40)
        expect(@target.background_image).to eq(@image.swt_image)
      end
  
      it "sets background image as image path" do
        @target = shell {
          background_image File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png')
        }
        
        expect(@target.background_image.bounds.width).to eq(132)
        expect(@target.background_image.bounds.height).to eq(40)
      end
      
      it "builds and sets background image via image keyword" do
        @target = shell {
          background_image img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        }
        
        expect(@target.background_image.bounds.width).to eq(132)
        expect(@target.background_image.bounds.height).to eq(40)
      end
      
      it 'builds and sets background image with initial fit_to_size but without scaling on resize' do
      end
      
      it 'builds and sets background image without scaling at all' do
      end
    end

  end
  
end
