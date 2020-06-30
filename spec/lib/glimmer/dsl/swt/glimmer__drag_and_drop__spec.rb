require "spec_helper"

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
      it "creates a DragSource and DropTarget widget with default Style DND::DROP_COPY" do
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
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_COPY)
      end
      
      it "creates a DragSource and DropTarget widget with specified style DND::DROP_LINK" do
        @target = shell {
          @drag_source_label = label {
            drag_source_style DND::DROP_LINK
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = label {
            drop_target_style DND::DROP_LINK
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
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_LINK)
      end
      
      it "creates a DragSource and DropTarget widget with specified style :drop_link" do
        @target = shell {
          @drag_source_label = label {
            drag_source_style :drop_link
            on_drag_start { |event|
            }
            on_drag_set_data { |event|
            }
            on_drag_finished { |event|
            }
          }
          @drop_target_label = label {
            drop_target_style 'drop_link'
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
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_LINK)
      end
      
      it "creates a DragSource and DropTarget widget with specified styles :drop_copy and :drop_move" do
        @target = shell {
          label {
            @drag_source = drag_source('drop_copy', 'drop_move') {
              on_drag_start { |event|
              }
              on_drag_set_data { |event|
              }
              on_drag_finished { |event|
              }          
            }
          }
          label {
            @drop_target = drop_target(:drop_copy, :drop_move) {
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
        }
  
        expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
        expect(@drag_source.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drag_source.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
  
        expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
        expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
        expect(@drop_target.has_style?([:drop_copy, :drop_move])).to be_truthy
        expect(@drop_target.swt_widget.getStyle).to eq(Glimmer::SWT::DNDProxy[:drop_copy, :drop_move])
      end
    end

    context 'auto-generated implicit drag_source and drop_target' do
      
      # TODO handle case where someone installs dnd listeners directly and inside drag_source
      it "creates an implicit DragSource and DropTarget with default style DND::DROP_COPY and default transfer :text"
      it "creates an implicit DragSource and DropTarget with default style DND::DROP_COPY, default transfer :text, default on_drag_enter listener that sets default operation DND::DROP_COPY"
      it "drag_source_style property"
      it "drag_source_effect property"
      it "drop_target_style property"
      it "	drop_target_effect property"
    end
  end
end
