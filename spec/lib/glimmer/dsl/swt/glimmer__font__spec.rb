require "spec_helper"

module GlimmerSpec
  describe "Glimmer Font" do
    include Glimmer

    it "sets font via hash having name, height, and style" do
      @target = shell {
        @label = label {
          font name: 'Times', height: 36, style: :normal
        }
      }

      font_data = @label.swt_widget.getFont.getFontData
      font_datum = font_data.first
      expect(font_datum.getName).to eq('Times')
      expect(font_datum.getHeight).to eq(36)
      expect(font_datum.getStyle).to eq(Glimmer::SWT::SWTProxy[:normal])
    end

    it "sets font with multiple styles" do
      @target = shell {
        @label = label {
          font style: [:bold, :italic]
        }
      }

      font_data = @label.swt_widget.getFont.getFontData
      font_datum = font_data.first
      expect(font_datum.getStyle).to eq(Glimmer::SWT::SWTProxy[:bold, :italic])
    end

    it "fails with a friendly message when label is given an invalid font style" do
      @target = shell {
        label {
          expect {
            font style: :deco
          }.to raise_error("deco is an invalid font style! Valid values are :normal, :bold, and :italic")
        }
      }
    end

    it "sets font style as SWT constant" do
      @target = shell {
        @label = label {
          font style: swt(:bold)
        }
      }

      font_data = @label.swt_widget.getFont.getFontData
      font_datum = font_data.first
      expect(font_datum.getStyle).to eq(Glimmer::SWT::SWTProxy[:bold])
    end

    it "sets font as SWT Font object (builds Font using font keyword without parent)" do
      @display = display
      @font = font name: 'Times', height: 36, style: :normal
      @target = shell {
        @label = label {
          font @font.swt_font
        }
      }

      font_data = @label.swt_widget.getFont.getFontData
      font_datum = font_data.first
      expect(font_datum.getName).to eq('Times')
      expect(font_datum.getHeight).to eq(36)
      expect(font_datum.getStyle).to eq(Glimmer::SWT::SWTProxy[:normal])
    end
  end
end
