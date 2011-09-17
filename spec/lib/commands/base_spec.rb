require 'spec_helper'
require 'fakefs'

describe Pagoda::Command::Base do

  before :all do
    @base = Pagoda::Command::Base.new(nil)
  end
  
  it "can find my current branch" do
    @base.find_branch.should == "master"
  end

  it "can find the current commit" do
    @base.find_commit.should == "#{`cat ./.git/refs/heads/master`.strip}"
  end

  it "writes the app data to a file" do
    FakeFS do
      @base.stub(:set_apps_file_permissions)
      @base.write_app("appname", "git@github.com/lyon/isawesome", "~/src/app")
      File.exists?("~/.pagoda/apps").should == true
    end
  end

  it "reads a file from the file system" do
    FakeFS do
      @base.read_apps.should == ["appname git@github.com/lyon/isawesome ~/src/app"]
    end
  end

  it "should be able to remove a app from the app list" do
    FakeFS do
      @base.remove_app "appname"
      @base.read_apps.should == []
    end
  end

  it "does some stuff" do
    @base.extract_possible_name.should == "pagodaconsole"
  end

  it "can locate my git root" do
    dir = Dir.pwd
    Dir.chdir('bin')
    @base.locate_app_root == dir
  end

  it "should report some errors when it cannot locat an app" do
    @base.stub(:find_app).and_return(false)
    @base.should_receive(:error).once
    @base.app
  end

  it "find app will give back the correct app" do
    @base.stub(:read_apps).and_return(["lyon giturl notapproot", "clay giturls approot"])
    @base.stub(:locate_app_root).and_return("approot")
    @base.find_app.should == "clay"
  end

  it "find app returns false if it cannot find the correct data" do
    @base.stub(:read_apps).and_return(["lyon giturl notapproot", "clay giturls approot"])
    @base.stub(:locate_app_root).and_return("not_correct_app_root")
    @base.find_app.should == false
  end

end