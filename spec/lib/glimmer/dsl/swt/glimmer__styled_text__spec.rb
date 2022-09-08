require 'spec_helper'

module GlimmerSpec
  describe "Glimmer Styled Text" do
    include Glimmer
    
    before(:all) do
      class StyledTextPresenter
        attr_accessor :text, :caret_offset, :selection_count, :selection, :top_index, :top_pixel
      end
    end

    after(:all) do
      %w[
        StyledTextPresenter
      ].each do |constant|
        Object.send(:remove_const, constant) if Object.const_defined?(constant)
      end
    end
    
    before do
      @process_event_loop_before_target_dispose = true
    end

    it "data-binds styled_text caret_offset" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\nstyled text widget."
      @styled_text_presenter.caret_offset = 6
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          caret_offset bind(@styled_text_presenter, :caret_offset)
        }
      }

      expect(@styled_text.text).to eq(@styled_text_presenter.text)
      expect(@styled_text.caret_offset).to eq(@styled_text_presenter.caret_offset)
      
      @styled_text_presenter.caret_offset = 12
      expect(@styled_text.caret_offset).to eq(@styled_text_presenter.caret_offset)

      event = Event.new
      event.keyCode = Glimmer::SWT::SWTProxy[:cr]
      event.doit = true
      event.character = "\n"
      event.display = @styled_text.swt_widget.display
      event.item = @styled_text.swt_widget
      event.widget = @styled_text.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:keyup]
      @styled_text.caret_offset = 21
      @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:keyup], event)

      expect(@styled_text_presenter.caret_offset).to eq(21)
    end

    it "data-binds styled_text caret_position to be compatible with text widget" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\nstyled text widget."
      @styled_text_presenter.caret_offset = 6
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          caret_position bind(@styled_text_presenter, :caret_offset)
        }
      }

      expect(@styled_text.text).to eq(@styled_text_presenter.text)
      expect(@styled_text.caret_offset).to eq(@styled_text_presenter.caret_offset)
      
      @styled_text_presenter.caret_offset = 12
      expect(@styled_text.caret_offset).to eq(@styled_text_presenter.caret_offset)

      event = Event.new
      event.keyCode = Glimmer::SWT::SWTProxy[:cr]
      event.doit = true
      event.character = "\n"
      event.display = @styled_text.swt_widget.display
      event.item = @styled_text.swt_widget
      event.widget = @styled_text.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:keyup]
      @styled_text.caret_offset = 21
      @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:keyup], event)

      expect(@styled_text_presenter.caret_offset).to eq(21)
    end
    
    it "data-binds styled_text selection_count" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\nstyled text widget."
      @styled_text_presenter.selection_count = 6
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          selection_count bind(@styled_text_presenter, :selection_count)
        }
      }

      expect(@styled_text.text).to eq(@styled_text_presenter.text)
      expect(@styled_text.selection_count).to eq(@styled_text_presenter.selection_count)
      
      @styled_text_presenter.selection_count = 12
      expect(@styled_text.selection_count).to eq(@styled_text_presenter.selection_count)

      # just a fake event (not accurate)
      event = Event.new
      event.keyCode = Glimmer::SWT::SWTProxy[:cr]
      event.doit = true
      event.character = "\n"
      event.display = @styled_text.swt_widget.display
      event.item = @styled_text.swt_widget
      event.widget = @styled_text.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:selection]
      @styled_text.selection = Point.new(0, 21)
      @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:selection], event)

      expect(@styled_text_presenter.selection_count).to eq(21)
    end
    
    it "data-binds styled_text selection" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\nstyled text widget."
      @styled_text_presenter.selection = Point.new(6, 6)
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          selection bind(@styled_text_presenter, :selection)
        }
      }

      async_exec {
        expect(@styled_text).to be_a(Glimmer::SWT::StyledTextProxy)
        expect(@styled_text.text).to eq(@styled_text_presenter.text)
        expect(@styled_text.selection.x).to eq(@styled_text_presenter.selection.x)
        expect(@styled_text.selection.y).to eq(@styled_text_presenter.selection.y)
      }
      
      async_exec {
        @styled_text_presenter.selection = Point.new(7, 12)
      }
      async_exec {
        expect(@styled_text.selection.x).to eq(@styled_text_presenter.selection.x)
        expect(@styled_text.selection.y).to eq(@styled_text_presenter.selection.y)
      }

      async_exec {
        @styled_text.selection = Point.new(0, 21)
      }
      async_exec {
        # just a fake event (not accurate)
        event = Event.new
        event.keyCode = Glimmer::SWT::SWTProxy[:cr]
        event.doit = true
        event.character = "\n"
        event.display = @styled_text.swt_widget.display
        event.item = @styled_text.swt_widget
        event.widget = @styled_text.swt_widget
        event.type = Glimmer::SWT::SWTProxy[:keyup]
        @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:keyup], event)
      }

      async_exec {
        expect(@styled_text_presenter.selection.x).to eq(0)
        expect(@styled_text_presenter.selection.y).to eq(21)
      }
    end

    it "data-binds styled_text top_index" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\n"*26
      @styled_text_presenter.top_index = 6
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          top_index bind(@styled_text_presenter, :top_index)
        }
      }

      expect(@styled_text.text).to eq(@styled_text_presenter.text)
      expect(@styled_text.top_index).to eq(@styled_text_presenter.top_index)
      
      @styled_text_presenter.top_index = 12
      expect(@styled_text.top_index).to eq(@styled_text_presenter.top_index)

      # just a fake event (not accurate)
      event = Event.new
      event.keyCode = Glimmer::SWT::SWTProxy[:cr]
      event.doit = true
      event.character = "\n"
      event.display = @styled_text.swt_widget.display
      event.item = @styled_text.swt_widget
      event.widget = @styled_text.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:keyup]
      @styled_text.top_index = 21
      @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:paint], event)

      expect(@styled_text_presenter.top_index).to eq(21)
    end
    
    it "data-binds styled_text top_pixel" do
      @styled_text_presenter = StyledTextPresenter.new
      @styled_text_presenter.text = "This is a multi line\nstyled text widget."*27
      @styled_text_presenter.top_pixel = 6
      @target = shell {
        @styled_text = styled_text {
          text  bind(@styled_text_presenter, :text)
          top_pixel bind(@styled_text_presenter, :top_pixel)
        }
      }

      expect(@styled_text.text).to eq(@styled_text_presenter.text)
      expect(@styled_text.top_pixel).to eq(@styled_text_presenter.top_pixel)
      
      @styled_text_presenter.top_pixel = 12
      expect(@styled_text.top_pixel).to eq(@styled_text_presenter.top_pixel)

      # just a fake event (not accurate)
      event = Event.new
      event.keyCode = Glimmer::SWT::SWTProxy[:cr]
      event.doit = true
      event.character = "\n"
      event.display = @styled_text.swt_widget.display
      event.item = @styled_text.swt_widget
      event.widget = @styled_text.swt_widget
      event.type = Glimmer::SWT::SWTProxy[:keyup]
      @styled_text.top_pixel = 21
      @styled_text.notifyListeners(Glimmer::SWT::SWTProxy[:paint], event)

      expect(@styled_text_presenter.top_pixel).to eq(21)
    end
        
  end
  
end
