require "spec_helper"

module GlimmerSpec
  describe Glimmer::SWT::WidgetProxy do
    include Glimmer
    
    it "wraps an existing swt_widget instead of initializing with init_args" do
      @target = shell
      @swt_scrolled_composite = ScrolledComposite.new(@target.swt_widget, swt(:none))
      @scrolled_composite = Glimmer::SWT::WidgetProxy.create(swt_widget: @swt_scrolled_composite)
      
      expect(@scrolled_composite.swt_widget).to eq(@swt_scrolled_composite)
      expect(@scrolled_composite.swt_widget.get_data('proxy')).to eq(@scrolled_composite)
      expect(@scrolled_composite.parent_proxy).to be_a(Glimmer::SWT::ShellProxy)
      expect(@scrolled_composite.parent_proxy.swt_widget).to eq(@swt_scrolled_composite.parent)
      
      @swt_composite = Composite.new(@swt_scrolled_composite, swt(:none))
      @composite = Glimmer::SWT::WidgetProxy.create(swt_widget: @swt_composite)
      
      # verify default initializers are called on widget
      expect(@swt_composite.get_layout).to be_a(GridLayout)
      
      # verify post_initialize_child is called on parent
      expect(@swt_scrolled_composite.content).to eq(@swt_composite)
    end
    
    it "wraps an existing composite without setting default layout if a layout exists" do
      @target = shell {
        @composite = composite {
          fill_layout
        }
      }
      
      expect(@composite.getLayout).to be_a(FillLayout)
      
      @wrapper = Glimmer::SWT::WidgetProxy.new(swt_widget: @composite.swt_widget)
      
      expect(@wrapper.swt_widget).to eq(@composite.swt_widget)
      expect(@wrapper.getLayout).to be_a(FillLayout)
    end
    
    it "wraps an existing group without setting default layout if a layout exists" do
      @target = shell {
        @group = group {
          fill_layout
        }
      }
      
      expect(@group.getLayout).to be_a(FillLayout)
      
      @wrapper = Glimmer::SWT::WidgetProxy.new(swt_widget: @group.swt_widget)
      
      expect(@wrapper.swt_widget).to eq(@group.swt_widget)
      expect(@wrapper.getLayout).to be_a(FillLayout)
    end
    
    it "sets data('proxy')" do
      @target = shell {
        @composite = composite {
          @label = label {
          }
        }
      }
      
      expect(@label.get_data('proxy')).to eq(@label)
      expect(@composite.get_data('proxy')).to eq(@composite)
    end
    
    it "returns data('proxy') in create method when passing a previously wrapped swt_widget" do
      @target = shell {
        @label = label
      }
      expect(Glimmer::SWT::WidgetProxy.create(swt_widget: @label.swt_widget)).to eq(@label)
    end
    
    it 'adds listener' do
      @target = shell {
        composite {
          @text = text {
            text "Howdy"
          }
          @text.on_verify_text do |verify_event|
            verify_event.doit = false if verify_event.text == "Hello"
          end
        }
      }

      @text.setText("Hi")
      expect(@text.getText).to eq("Hi")

      @text.setText("Hello")
      expect(@text.getText).to eq("Hi")
    end

    it 'adds content' do
      @target = shell {
        minimum_size 50, 20
      }

      @target.content {
        minimum_size 300, 200
        composite {
          @text = text {
            text "Howdy"
          }
        }
      }

      expect(@target.getMinimumSize.x).to eq(300)
      expect(@target.getMinimumSize.y).to eq(200)
      expect(@text.getText).to eq("Howdy")
    end

    context 'UI code execution' do
      after do
        if @target && !@target.isDisposed
          @target.async_exec do
            @target.dispose
          end
          @target.start_event_loop
        end
      end

      it "syncronously and asynchronously executes UI code" do
        @target = shell {
          @text = text {
            text "text1"
          }
        }

        @target.async_exec do
          expect(@text.getText).to eq("text2")
        end

        # This takes prioerity over async_exec
        @target.sync_exec do
          @text.setText("text2")
        end
      end
    end

    describe '#pack_same_size' do
      it 'packs composite widget content while maintaining the same size despite child text widget needing more space with more content' do
        @target = shell {
          alpha 0 # keep invisible while running specs
          grid_layout 1, false
          @composite = composite {
            @text = text {
              layout_data :fill, :fill, true, true
              text 'A'
            }
          }
        }

        @target.pack

        text_width = @text.getSize.x
        composite_width = @composite.getSize.x
        shell_width = @target.getSize.x

        @text.setText('A very long text it cannot fit in the screen if you keep reading on' + ' and on'*60)
        @composite.pack_same_size

        expect(@text.getSize.x).to eq(text_width)
        expect(@composite.getSize.x).to eq(composite_width)
        expect(@target.getSize.x).to eq(shell_width)
      end
      it 'packs text widget content while maintaining the same size despite needing more space with more content' do
        @target = shell {
          alpha 0 # keep invisible while running specs
          grid_layout 1, false
          @text = text {
            layout_data :fill, :fill, true, true
            text 'A'
          }
        }

        @target.pack

        text_width = @text.getSize.x
        shell_width = @target.getSize.x

        @text.setText('A very long text it cannot fit in the screen if you keep reading on' + ' and on'*60)
        @text.pack_same_size

        expect(@text.getSize.x).to eq(text_width)
        expect(@target.getSize.x).to eq(shell_width)
      end
    end
  end
end
