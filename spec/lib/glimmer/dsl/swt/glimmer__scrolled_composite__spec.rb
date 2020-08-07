require "spec_helper"

module GlimmerSpec
  describe 'Glimmer Scrolled Composite' do
    include Glimmer

    it 'renders a scrolled composite with v_scroll and h_scroll styles' do
      @target = shell {
        @scrolled_composite = scrolled_composite {
          @label = label {
            text "Hello"
          }
        }
      }

      expect(@target).to be_a(Glimmer::SWT::ShellProxy)
      expect(@scrolled_composite).to be_a(Glimmer::SWT::ScrolledCompositeProxy)
      expect(@scrolled_composite).to have_style(:h_scroll)
      expect(@scrolled_composite).to have_style(:v_scroll)
      expect(@scrolled_composite.swt_widget.content).to eq(@label.swt_widget)
      expect(@scrolled_composite.swt_widget.expand_horizontal).to eq(true)
      expect(@scrolled_composite.swt_widget.expand_vertical).to eq(true)
      expect(@scrolled_composite.swt_widget.min_width).to eq(50)
      expect(@scrolled_composite.swt_widget.min_height).to eq(33)
      expect(@label.swt_widget.parent).to eq(@scrolled_composite.swt_widget)
    end
    
    it 'renders a scrolled composite with v_scroll and h_scroll styles in addition to specified style' do
      @target = shell {
        @scrolled_composite = scrolled_composite(:border) {
        }
      }

      expect(@scrolled_composite).to_not have_style(:h_scroll)
      expect(@scrolled_composite).to_not have_style(:v_scroll)
      expect(@scrolled_composite).to have_style(:border)
    end
    
    it 'renders a scrolled composite without v_scroll and h_scroll styles if using an integer SWT style' do
      @target = shell {
        @scrolled_composite = scrolled_composite(swt(:none)) {
        }
      }

      expect(@target).to be_a(Glimmer::SWT::ShellProxy)
      expect(@scrolled_composite).to be_a(Glimmer::SWT::ScrolledCompositeProxy)
      expect(@scrolled_composite).to_not have_style(:h_scroll)
      expect(@scrolled_composite).to_not have_style(:v_scroll)
    end
  end
end
