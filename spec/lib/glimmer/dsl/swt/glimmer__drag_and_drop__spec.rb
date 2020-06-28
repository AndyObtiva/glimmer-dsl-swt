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

    it "creates a DragSource and DropTarget widget with default Style DND::DROP_COPY" do
      @target = shell {
        label {
          @drag_source = drag_source {            
          }
        }
        label {
          @drop_target = drop_target {            
          }
        }
      }

      expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
      expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
      expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_COPY)

      expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
      expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
      expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_COPY)
    end
    
    it "creates a DragSource and DropTarget widget with specified style DND::DROP_LINK" do
      @target = shell {
        label {
          @drag_source = drag_source(DND::DROP_LINK) {
          }
        }
        label {
          @drop_target = drop_target(DND::DROP_LINK) {
          }
        }
      }

      expect(@drag_source).to be_a(Glimmer::SWT::WidgetProxy)
      expect(@drag_source.swt_widget).to be_a(org.eclipse.swt.dnd.DragSource)
      expect(@drag_source.swt_widget.getStyle).to eq(DND::DROP_LINK)

      expect(@drop_target).to be_a(Glimmer::SWT::WidgetProxy)
      expect(@drop_target.swt_widget).to be_a(org.eclipse.swt.dnd.DropTarget)
      expect(@drop_target.swt_widget.getStyle).to eq(DND::DROP_LINK)
    end
    
    it "creates a DragSource and DropTarget widget with specified style :drop_link" do
      @target = shell {
        label {
          @drag_source = drag_source(:drop_link) {
          }
        }
        label {
          @drop_target = drop_target('drop_link') {
          }
        }
      }

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
          }
        }
        label {
          @drop_target = drop_target(:drop_copy, :drop_move) {
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
end
