require "spec_helper"

module GlimmerSpec
  describe Glimmer::SWT::WidgetProxy do
    include Glimmer

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

      @text.swt_widget.setText("Hi")
      expect(@text.swt_widget.getText).to eq("Hi")

      @text.swt_widget.setText("Hello")
      expect(@text.swt_widget.getText).to eq("Hi")
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

      expect(@target.swt_widget.getMinimumSize.x).to eq(300)
      expect(@target.swt_widget.getMinimumSize.y).to eq(200)
      expect(@text.swt_widget.getText).to eq("Howdy")
    end

    context 'UI code execution' do
      after do
        if @target && !@target.swt_widget.isDisposed
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
          expect(@text.swt_widget.getText).to eq("text2")
        end

        # This takes prioerity over async_exec
        @target.sync_exec do
          @text.swt_widget.setText("text2")
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

        text_width = @text.swt_widget.getSize.x
        composite_width = @composite.swt_widget.getSize.x
        shell_width = @target.swt_widget.getSize.x

        @text.swt_widget.setText('A very long text it cannot fit in the screen if you keep reading on' + ' and on'*60)
        @composite.pack_same_size

        expect(@text.swt_widget.getSize.x).to eq(text_width)
        expect(@composite.swt_widget.getSize.x).to eq(composite_width)
        expect(@target.swt_widget.getSize.x).to eq(shell_width)
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

        text_width = @text.swt_widget.getSize.x
        shell_width = @target.swt_widget.getSize.x

        @text.swt_widget.setText('A very long text it cannot fit in the screen if you keep reading on' + ' and on'*60)
        @text.pack_same_size

        expect(@text.swt_widget.getSize.x).to eq(text_width)
        expect(@target.swt_widget.getSize.x).to eq(shell_width)
      end
    end

    context 'drag & drop' do
      describe 'transfer property' do
        it 'accepts transfer property for a drag_source as raw value' do
          @target = shell {
            label {
              @drag_source = drag_source {
                transfer [org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer)
              }
              @drop_target = drop_target {
                transfer [org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer)
              }
            }
          }
          
          expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
          expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
        end
        
        it 'accepts transfer property for a drag_source as raw array of multiple values' do
          @target = shell {
            label {
              @drag_source = drag_source {
                transfer [org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer)
              }
              @drop_target = drop_target {
                transfer [org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer)
              }
            }
          }
          
          expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
          expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
        end
        
        it 'accepts transfer property for a drag_source via symbol (translated into Java Transfer object)' do
          @target = shell {
            label {
              @drag_source = drag_source {
                transfer :text
              }
              @drop_target = drop_target {
                transfer :text
              }
            }
          }
          
          expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
          expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
        end
        
        it 'accepts transfer property for a drag_source via string (translated into Java Transfer object)' do
          @target = shell {
            label {
              @drag_source = drag_source {
                transfer 'url'
              }
              @drop_target = drop_target {
                transfer 'url'
              }
            }
          }
          
          expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.URLTransfer.getInstance].to_java(Transfer))
          expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.URLTransfer.getInstance].to_java(Transfer))
        end
        
        it 'accepts multiple values for transfer property in an array' do
          @target = shell {
            label {
              @drag_source = drag_source {
                transfer [:file, :html, :image, :rtf, :text, :url]
              }
              @drop_target = drop_target {
                transfer [:file, :html, :image, :rtf, :text, :url]
              }
            }
          }
          
          expect(@drag_source.swt_widget.getTransfer).to eq([
              org.eclipse.swt.dnd.FileTransfer.getInstance,
              org.eclipse.swt.dnd.HTMLTransfer.getInstance,
              org.eclipse.swt.dnd.ImageTransfer.getInstance,
              org.eclipse.swt.dnd.RTFTransfer.getInstance,
              org.eclipse.swt.dnd.TextTransfer.getInstance,
              org.eclipse.swt.dnd.URLTransfer.getInstance,
            ].to_java(Transfer))          
          expect(@drop_target.swt_widget.getTransfer).to eq([
              org.eclipse.swt.dnd.FileTransfer.getInstance,
              org.eclipse.swt.dnd.HTMLTransfer.getInstance,
              org.eclipse.swt.dnd.ImageTransfer.getInstance,
              org.eclipse.swt.dnd.RTFTransfer.getInstance,
              org.eclipse.swt.dnd.TextTransfer.getInstance,
              org.eclipse.swt.dnd.URLTransfer.getInstance,
            ].to_java(Transfer))
        end
      end  
    end
  end
end
