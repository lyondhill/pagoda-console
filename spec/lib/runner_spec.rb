require 'spec_helper'

describe Pagoda::Runner do

  it "gives the command back" do
    Pagoda::Runner.go("command", nil).should == nil
  end

end
