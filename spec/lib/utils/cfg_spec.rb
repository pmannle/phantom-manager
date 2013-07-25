require 'spec_helper'
require 'utils/cfg'

module Utils
  describe Cfg do
    subject {Cfg}

    it "should be able to set" do
      Cfg.rails_root= "some path"
      Cfg.rails_root.should eq "some path"
      Cfg.rails_root= "another path"
      Cfg.rails_root.should eq "another path"
    end
  end
end
