require 'spec_helper'
require 'fakefs'

describe Pagoda::Command::Base do

  before :all do
    @base = Pagoda::Command::Base.new({},{},[])
  end
  
  it "returns the remote given" do
    @base = Pagoda::Command::Base.new({},{:remote => "notpagoda"},[])
    @base.remote.should == "notpagoda"
  end

  it "returns a default remote" do
    @base.remote.should == "pagoda"
  end

  it "can gather an application name from anywhere" do
    glob = Pagoda::Command::Base.new({:app => "appname"},{},[])
    opt = Pagoda::Command::Base.new({},{:app => "appnamo"},[])
    arg = Pagoda::Command::Base.new({},{},["appnama"])
    glob.app.should == "appname"
    opt.app.should == "appnamo"
    arg.app.should == "appnama"
  end

  it "retrieves the app.id from git config" do
    `git config --add pagoda.id someid`
    @base.extract_app_from_git_config.should == "someid"
    `git config --unset pagoda.id`
  end

  
  


end