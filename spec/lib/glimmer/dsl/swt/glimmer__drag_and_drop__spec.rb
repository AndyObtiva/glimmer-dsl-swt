require 'spec_helper'
require 'ostruct'

module GlimmerSpec
  describe "Glimmer Drag & Drop" do
    include Glimmer
    
    before(:all) do
      class ::RedLabel
        include Glimmer::UI::CustomWidget

        body {
          label {
            background :red
          }
        }
      end
    end

    after(:all) do
      Object.send(:remove_const, :RedLabel) if Object.const_defined?(:RedLabel)
    end
    
    context 'explicit drag_source and drop_target' do
      it "creates a DragSource and DropTarget with default Style DND::DROP_COPY and transfer property as default TextTransfer value" do
        @target = shell {
          @drag_source_label = label {
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = label {
            on_drag_enter { |event|
            }
            on_drag_leave { |event|
            }
            on_drag_operation_changed { |event|
            }
            on_drag_over { |event|
            }
            on_drop { |event|
            }
            on_drop_accept { |event|
            }
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_COPY)
        expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_COPY)        
        expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))        
      end
      
      it "creates a DragSource and DropTarget with default Style DND::DROP_COPY and transfer property as default TextTransfer value on CustomWidget" do
        @target = shell {
          @drag_source_label = red_label {
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = red_label {
            on_drag_enter { |event|
            }
            on_drag_leave { |event|
            }
            on_drag_operation_changed { |event|
            }
            on_drag_over { |event|
            }
            on_drop { |event|
            }
            on_drop_accept { |event|
            }
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_COPY)
        expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_COPY)        
        expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance].to_java(Transfer))        
      end
      
      it "creates a DragSource and DropTarget with specified style DND::DROP_LINK and transfer property of HTMLTransfer value" do
        @target = shell {
          @drag_source_label = label { |drag_source_label_proxy|
            drag_source_style DND::DROP_LINK
            drag_source_transfer [org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer)
            @drag_source_effect_object = DragSourceEffect.new(drag_source_label_proxy.swt_widget)
            drag_source_effect @drag_source_effect_object
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = label { |drop_target_label_proxy|
            drop_target_style DND::DROP_LINK
            drop_target_transfer [org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer)
            @drop_target_effect_object = DropTargetEffect.new(drop_target_label_proxy.swt_widget)
            drop_target_effect @drop_target_effect_object
            on_drag_enter { |event|
            }
            on_drag_leave { |event|
            }
            on_drag_operation_changed { |event|
            }
            on_drag_over { |event|
            }
            on_drop { |event|
            }
            on_drop_accept { |event|
            }
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_LINK)
        expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
        expect(@drag_source.swt_widget.getDragSourceEffect).to eq(@drag_source_effect_object)
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_LINK)
        expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))        
        expect(@drop_target.swt_widget.getDropTargetEffect).to eq(@drop_target_effect_object)
      end
      
      it "creates a DragSource and DropTarget with specified style :drop_link and transfer property of :html value" do
        @target = shell {
          @drag_source_label = label {
            drag_source_style :drop_link
            drag_source_transfer :html
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = label {
            drop_target_style 'drop_link'
            drop_target_transfer :html
            on_drag_enter { |event|
            }
            on_drag_leave { |event|
            }
            on_drag_operation_changed { |event|
            }
            on_drag_over { |event|
            }
            on_drop { |event|
            }
            on_drop_accept { |event|
            }
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_LINK)
        expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_LINK)
        expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))        
      end
      
      it "creates a DragSource and DropTarget with specified styles :drop_copy and :drop_move and transfer property as an array of values" do
        @target = shell {
          @drag_source_label = label {
            drag_source_style 'drop_copy', 'drop_move'
            drag_source_transfer :text, :html
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }          
          }
          @drop_target_label = label {
            drop_target_style :drop_copy, :drop_move
            drop_target_transfer :text, :html
            on_drag_enter { |event|
            }
            on_drag_leave { |event|
            }
            on_drag_operation_changed { |event|
            }
            on_drag_over { |event|
            }
            on_drop { |event|
            }
            on_drop_accept { |event|
            }          
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drag_source.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
        expect(@drag_source.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
  
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drop_target.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
        expect(@drop_target.swt_widget.getTransfer).to eq([org.eclipse.swt.dnd.TextTransfer.getInstance, org.eclipse.swt.dnd.HTMLTransfer.getInstance].to_java(Transfer))
      end
      
      it "creates an implicit DragSource and DropTarget with default style DND::DROP_COPY, default transfer :text, default on_drag_enter listener that sets default operation DND::DROP_COPY on_drag_enter in DropTarget" do
        @target = shell {
          @drag_source_label = label {
            drag_source_style 'drop_copy', 'drop_move'
            drag_source_transfer :file, :html, :image, :rtf, :text, :url
          }
          @drop_target_label = label {
            drop_target_style :drop_copy, :drop_move
            drop_target_transfer ['file', 'html', 'image', :rtf, :text, :url]
          }
        }
  
        @drag_source = @drag_source_label.drag_source_proxy  
        @drop_target = @drop_target_label.drop_target_proxy

        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drag_source.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
        expect(@drag_source.swt_widget.getTransfer).to eq([
          org.eclipse.swt.dnd.FileTransfer.getInstance,
          org.eclipse.swt.dnd.HTMLTransfer.getInstance,
          org.eclipse.swt.dnd.ImageTransfer.getInstance,
          org.eclipse.swt.dnd.RTFTransfer.getInstance,
          org.eclipse.swt.dnd.TextTransfer.getInstance,
          org.eclipse.swt.dnd.URLTransfer.getInstance,
        ].to_java(Transfer))
  
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drop_target.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
        expect(@drop_target.swt_widget.getTransfer).to eq([
          org.eclipse.swt.dnd.FileTransfer.getInstance,
          org.eclipse.swt.dnd.HTMLTransfer.getInstance,
          org.eclipse.swt.dnd.ImageTransfer.getInstance,
          org.eclipse.swt.dnd.RTFTransfer.getInstance,
          org.eclipse.swt.dnd.TextTransfer.getInstance,
          org.eclipse.swt.dnd.URLTransfer.getInstance,
        ].to_java(Transfer))
        
        listeners = @drop_target.swt_widget.getDropListeners
        event = OpenStruct.new
        listeners.to_a[0].dragEnter(event)
        expect(event.detail).to eq(DND::DROP_COPY)
      end
    end
  end
end
