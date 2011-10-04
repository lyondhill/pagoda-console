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
    @app.client.should_receive(:app_create).and_return({:_id => "1234"})
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

  it "bonks if the names are the same" do
    @app.should_receive(:error).with("New name and existiong name cannot be the same")
    @app.client.stub(:app_update)
    @app.stub(:display)
    @app.rename
  end

  it "bonks if we raise an error in anyway" do
    app = Pagoda::Command::App.new({},{:app => "firstname"},['name'])
    app.should_receive(:error).with("Given name was either invalid or already in use")
    app.client.stub(:app_update).and_raise("BOOO HOO")
    app.stub(:display)
    app.rename
  end

  it "can clone a pagoda repo" do
    @app.client.stub(:app_info).and_return({:_id => "superawesomeid"})
    @app.should_receive(:git).with("clone git@pagodabox.com:superawesomeid.git name")
    @app.should_receive(:git).with("config --add pagoda.id superawesomeid")
    @app.stub(:display)
    Dir.stub!(:chdir)
    @app.clone
  end

  it "calls the rewinda" do
    @app.client.should_receive(:app_rollback)
    @app.stub(:display)
    @app.stub(:loop_transaction)
    @app.rollback
  end

end