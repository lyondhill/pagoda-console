require 'spec_helper'
require 'fakefs'

describe Pagoda::Command::Base do

  before :all do
    @base = Pagoda::Command::Base.new({},{},[])
  end
  
  it "can find my current branch" do
    @base.find_branch.should == "master"
  end

  it "can find the current commit" do
    @base.find_commit.should == "#{`cat ./.git/refs/heads/master`.strip}"
  end

  it "can locate my git root" do
    dir = Dir.pwd
    Dir.chdir('bin')
    @base.locate_app_root == dir
  end

end