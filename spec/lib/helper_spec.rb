require 'spec_helper'

class Tclass
  include Pagoda::Helpers

end

describe Pagoda::Helpers do

  before :each do
    @cla = Tclass.new
  end

  it "has git?" do
    @cla.has_git?.should == true
  end

  it "builds a nice indent" do
    @cla.build_indent(3).should == "      "
  end

  it "formats time pretty" do
    t = Time.now
    @cla.format_date(t).should == t.strftime("%Y-%m-%d %H:%M %Z")
  end

  it "can check the operationg system" do
    @cla.running_on_a_mac?.should_not == false
  end


end
