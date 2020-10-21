require "spec_helper"

module GlimmerSpec
  describe "Glimmer SashForm" do
    include Glimmer

    it "sets weights using an array after content of sash_form" do
      @target = shell {
        @sash_form = sash_form {
          @composite1 = composite
          @composite2 = composite
          weights [1, 2]
        }
      }

      expect(@sash_form.weights).to eq([333,666].to_java(Java::int))
    end

    it "sets weights using a splatted array after content of sash_form" do
      @target = shell {
        @sash_form = sash_form {
          @composite1 = composite
          @composite2 = composite
          weights 1, 2
        }
      }

      expect(@sash_form.weights).to eq([333,666].to_java(Java::int))
    end

    it "sets weights using a splatted array before content of sash_form" do
      @target = shell {
        @sash_form = sash_form {
          weights 1, 2
          @composite1 = composite
          @composite2 = composite
        }
      }

      expect(@sash_form.weights).to eq([333,666].to_java(Java::int))
    end

  end
end
