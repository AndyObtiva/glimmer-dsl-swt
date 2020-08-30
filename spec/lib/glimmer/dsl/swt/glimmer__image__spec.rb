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
        
        label_image = @label.swt_widget.getImage
        label_image_proxy = @label.swt_widget.getData('image_proxy')
        expect(label_image).to eq(@image.swt_image)
        expect(label_image_proxy.swt_image.bounds.width).to eq(132)
        expect(label_image_proxy.swt_image.bounds.height).to eq(40)
        expect(label_image_proxy.aspect_ratio).to eq(true)
      end
  
      it "builds image proxy and sets image as ImageProxy" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'))
        @target = shell {
          @label = label {
            image @image
          }
        }
        
        label_image = @label.swt_widget.getImage
        label_image_proxy = @label.swt_widget.getData('image_proxy')
        expect(label_image_proxy).to eq(@image)        
        expect(label_image).to eq(@image.swt_image)
        expect(label_image.bounds.width).to eq(132)
        expect(label_image.bounds.height).to eq(40)
        expect(label_image_proxy.aspect_ratio).to eq(true)
      end
  
      it "builds image proxy and sets image as ImageProxy with specified width (maintaining aspect ratio)" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'), width: 264)
        @target = shell {
          @label = label {
            image @image
          }
        }        
        
        label_image = @label.swt_widget.getImage
        label_image_proxy = @label.swt_widget.getData('image_proxy')
        expect(label_image_proxy).to eq(@image)        
        expect(label_image).to eq(@image.swt_image)
        expect(label_image.bounds.width).to eq(264)
        expect(label_image.bounds.height).to eq(80)
        expect(label_image_proxy.aspect_ratio).to eq(true)
      end
  
      it "builds image proxy and sets image as ImageProxy with specified height (maintaining aspect ratio)" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'), height: 80)
        @target = shell {
          @label = label {
            image @image
          }
        }
        
        label_image = @label.swt_widget.getImage
        label_image_proxy = @label.swt_widget.getData('image_proxy')
        expect(label_image_proxy).to eq(@image)        
        expect(label_image).to eq(@image.swt_image)
        expect(label_image.bounds.width).to eq(264)
        expect(label_image.bounds.height).to eq(80)
        expect(label_image_proxy.aspect_ratio).to eq(true)
      end
  
      it "builds image proxy and sets image as ImageProxy with specified width and height (not maintaining aspect ratio)" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'), width: 100, height: 100)
        @target = shell {
          @label = label {
            image @image
          }
        }
        
        label_image = @label.swt_widget.getImage
        label_image_proxy = @label.swt_widget.getData('image_proxy')
        expect(label_image_proxy).to eq(@image)        
        expect(label_image).to eq(@image.swt_image)
        expect(label_image.bounds.width).to eq(100)
        expect(label_image.bounds.height).to eq(100)
        expect(label_image_proxy.aspect_ratio).to eq(false)
      end
      
      xit "builds image proxy and sets image as ImageProxy with specified width and height (not maintaining aspect ratio)" do
        @image = img(File.join(ROOT_PATH, 'images', 'glimmer-hello-world.png'), width: 100, height: 100)
        @target = shell {
          @label = label {
            image @image
          }
        }
        
        expect(@image.bounds.width).to eq(100)
        expect(@image.bounds.height).to eq(100)
        expect(@label.swt_widget.getImage).to eq(@image.swt_image)
      end
      
      xit "builds image proxy and sets image as ImageProxy with widget width (maintaining aspect ratio)"
      xit "builds image proxy and sets image as ImageProxy with widget height (maintaining aspect ratio)"
      xit "builds image proxy and sets image as ImageProxy with widget width and widget height (not maintaining aspect ratio)"
      xit "builds image proxy and sets image as raw args with widget width and widget height (not maintaining aspect ratio)"
  
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
