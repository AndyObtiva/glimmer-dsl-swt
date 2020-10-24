require "spec_helper"

module GlimmerSpec
  describe "Glimmer Expand Item" do
    include Glimmer

    it "renders expand item composite with default layout" do
      @target = shell {
        @expand_bar = expand_bar {
          @expand_item_composite = expand_item {
            text "Expand Item 1"
            label {text "Hello"}
          }
        }
      }

      expect(@target).to_not be_nil
      expect(@target.swt_widget).to_not be_nil
      expect(@expand_bar.swt_widget.items.size).to eq(1)
      expect(@expand_item_composite.swt_widget).to be_instance_of(Composite)
      expect(@expand_bar.swt_widget.items[0].control).to eq(@expand_item_composite.swt_widget)
      expect(@expand_item_composite.swt_expand_item.getText).to eq("Expand Item 1")
      expect(@expand_item_composite.swt_expand_item.getExpanded).to be_truthy
      expect(@expand_item_composite.swt_widget.getLayout).to_not be_nil
      expect(@expand_item_composite.swt_widget.getLayout).to be_instance_of(FillLayout)
      expect(@expand_item_composite.swt_widget.getLayout.marginWidth).to eq(0)
      expect(@expand_item_composite.swt_widget.getLayout.marginHeight).to eq(0)
      expect(@expand_item_composite.swt_widget.getLayout.spacing).to eq(0)
      unless OS.linux?
        expect(@expand_item_composite.swt_widget.bounds.height > 0).to be_truthy
      end
    end
    
    it "renders expand item composite with a specified height and not expanded" do
      @target = shell {
        @expand_bar = expand_bar {
          @expand_item_composite = expand_item {
            text "Expand Item 1"
            height 501
            expanded false
            label {text "Hello"}
          }
        }
      }

      expect(@target).to_not be_nil
      expect(@target.swt_widget).to_not be_nil
      expect(@expand_bar.swt_widget.items.size).to eq(1)
      expect(@expand_item_composite.swt_widget).to be_instance_of(Composite)
      expect(@expand_bar.swt_widget.items[0].control).to eq(@expand_item_composite.swt_widget)
      expect(@expand_item_composite.swt_expand_item.getText).to eq("Expand Item 1")
      expect(@expand_item_composite.swt_expand_item.getExpanded).to be_falsey
      unless OS.linux?
        expect(@expand_item_composite.swt_widget.bounds.height).to eq(500) # 501 loses 1 pixel, so 500 (not really sure why, but that's how it works)
      end
    end
    
    it "renders expand item composite with invalid parent (not an expand bar)" do
      @target = shell
      expect {
        @target.content {
          @invalid_parent = composite {
            @expand_item_composite = expand_item {
              text "Expand Item 1"
              label {text "Hello"}
            }
          }
        }
      }.to raise_error(StandardError)
    end

    it "renders expand item composite with fill layout" do
      @target = shell {
        @expand_bar = expand_bar {
          @expand_item_composite = expand_item {
            grid_layout 1, false
            text "Expand Item 2"
            label {text "Hello"}
          }
        }
      }

      expect(@target).to_not be_nil
      expect(@target.swt_widget).to_not be_nil
      expect(@expand_bar.swt_widget.items.size).to eq(1)
      expect(@expand_item_composite.swt_widget).to be_instance_of(Composite)
      expect(@expand_bar.swt_widget.items[0].control).to eq(@expand_item_composite.swt_widget)
      expect(@expand_item_composite.swt_expand_item.getText).to eq("Expand Item 2")
      expect(@expand_item_composite.swt_widget.getLayout).to_not be_nil
      expect(@expand_item_composite.swt_widget.getLayout).to be_instance_of(GridLayout)
    end

  end
end
