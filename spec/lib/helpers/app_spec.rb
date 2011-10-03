require 'spec_helper'
require 'pagoda/cli/helpers'

describe Pagoda::Command::App do
  
  before :all do
    @app = Pagoda::Command::App.new({},{},['name'])
  end

  it "Should error if no apps are found" do
    @app.client.stub(:app_list).and_return({})
    @app.should_receive(:error).with(["looks like you haven't launched any apps", "type 'pagoda create' to creat this project on pagodabox"])
    @app.list
  end

  it "should attempt to display the apps " do
    @app.client.stub(:app_list).and_return([{:name => "bob"}, {:name => "saget"}])
    @app.should_receive(:display).with(no_args).exactly(3).times
    @app.should_receive(:display).with("APPS")
    @app.should_receive(:display).with("//////////////////////////////////")
    @app.should_receive(:display).with("- bob")
    @app.should_receive(:display).with("- saget")
    @app.list
  end

  it "displays the app info" do
    response = {
      :name => "name",
      :git_url => "github.com",
      :state => "CREATING"
    }
    @app.client.should_receive(:app_info).with("name").and_return(response)
    @app.should_receive(:display).with(no_args).exactly(2).times
    @app.should_receive(:display).with("INFO - name")
    @app.should_receive(:display).with("//////////////////////////////////")
    @app.should_receive(:display).with("name       :  name")
    @app.should_receive(:display).with("clone_url  :  github.com")
    @app.should_receive(:display).with("State      :  CREATING")
    @app.info
  end

  it "Is able to create an application" do
    @app.stub(:app).and_return("application")
    @app.stub(:display)
    @app.client.should_receive(:app_available?).and_return(true)
    @app.client.should_receive(:app_create).and_return({:id => "1234"})
    @app.should_receive(:create_git_remote)
    @app.create
  end

  it "deploys a new commit" do
    @app.stub(:app).and_return("cowboy")
    @app.client.stub(:app_info).and_return({:transactions => []})
    @app.stub(:display)
    @app.client.should_receive(:app_deploy).once
    @app.deploy
  end


end