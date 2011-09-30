require 'spec_helper'
require 'pagoda/cli/helpers'

describe Pagoda::Command::App do
  
  before :all do
    @app = Pagoda::Command::App.new({},{},['name'])
  end

  it "Should error if no apps are found" do
    @app.client.stub(:app_list).and_return({})
    @app.should_receive(:error).with(["looks like you haven't launched any apps", "type 'pagoda launch' to launch this project"])
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
      :name => "Appname",
      :git_url => "github.com",
      :owner => {
        :username => "lyon",
        :email => "lyon@pagodabox.com"
      },
      :collaborators => [
        {
          :username => "tyler",
          :email => "tyler@pagodabox.com"
        },
        {
          :username => "clay",
          :email => "clay@pagodabox.com"
        }
      ]
    }
    @app.client.should_receive(:app_info).with("appname").and_return(response)
    @app.stub(:app).and_return("appname")
    @app.should_receive(:display).with(no_args).exactly(4).times
    @app.should_receive(:display).with("INFO - Appname")
    @app.should_receive(:display).with("//////////////////////////////////")
    @app.should_receive(:display).with("name       :  Appname")
    @app.should_receive(:display).with("clone_url  :  github.com")
    @app.should_receive(:display).with("owner")
    @app.should_receive(:display).with("username :  lyon", true, 2)
    @app.should_receive(:display).with("email    :  lyon@pagodabox.com", true, 2)
    @app.should_receive(:display).with("collaborators")
    @app.should_receive(:display).with("username :  tyler", true, 2)
    @app.should_receive(:display).with("email    :  tyler@pagodabox.com", true, 2)
    @app.should_receive(:display).with("username :  clay", true, 2)
    @app.should_receive(:display).with("email    :  clay@pagodabox.com", true, 2)
    @app.info
  end

  it "Is able to create an application" do
    @app.stub(:app).and_return(false)
    @app.stub(:display)
    Pagoda::Runner.stub(:run_internal)
    @app.client.should_receive(:app_create)
    @app.client.stub(:app_info).and_return({:transactions => []})
    @app.create
  end

  it "deploys a new commit" do
    @app = Pagoda::Command::App.new(['--latest'])
    @app.stub(:app).and_return("cowboy")
    @app.client.stub(:app_info).and_return({:transactions => []})
    @app.stub(:display)
    @app.client.should_receive(:app_deploy).once
    @app.deploy
  end


end