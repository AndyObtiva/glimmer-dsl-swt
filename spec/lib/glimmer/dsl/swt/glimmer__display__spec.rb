require "spec_helper"

module GlimmerSpec
  describe "Glimmer Display" do
    include Glimmer

    context 'standard operation' do
      after do
        @target2.dispose if @target2
      end

      it "instantiates display" do
        @target = display

        expect(@target).to be_a(Glimmer::SWT::DisplayProxy)
        expect(@target.swt_display).to be_a(Display)
        expect(@target.swt_display.isDisposed).to be_falsey
        expect(@target.isDisposed).to be_falsey

        @target2 = display
        expect(@target2.swt_display).to eq(@target.swt_display)

        @target2.dispose
        @target2 = display
        expect(@target2.swt_display).to_not eq(@target.swt_display)
      end
      
      it "sets data('proxy')" do
        @target = display
        
        expect(@target.swt_display.get_data('proxy')).to eq(@target)
      end
          
    end

    context 'filter listeners' do
      it 'adds filter listener' do
        @display = display {
          on_swt_show {
            @shown = true
          }
        }
        @target = shell {
          alpha 0 # keep invisible while running specs
        }
        async_exec do
          expect(@shown).to eq(true)
          @target.dispose
        end
        @target.open
      end
    end

    context 'UI code execution' do
      after do
        if @target
          @target.async_exec do
            @target.dispose
          end
          @target.start_event_loop
        end
      end

      it 'asyncronously executes UI code' do
        @target = shell {
          @text = text {
            text "text1"
          }
        }

        Glimmer::SWT::DisplayProxy.instance.swt_display.async_exec do
          @text.swt_widget.setText("text2")
        end

        expect(@text.swt_widget.getText).to_not eq("text2")

        Glimmer::SWT::DisplayProxy.instance.async_exec do
          expect(@text.swt_widget.getText).to eq("text2")
        end
      end

      it "syncronously executes UI code" do
        @target = shell {
          @text = text {
            text "text1"
          }
        }

        display.swt_display.async_exec do
          expect(@text.swt_widget.getText).to eq("text2")
        end

        # This takes prioerity over async_exec
        display.sync_exec do
          @text.swt_widget.setText("text2")
        end
      end
    end
    
  end
end
