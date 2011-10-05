require 'spec_helper'
require 'pagoda/cli/helpers'

describe Pagoda::Command::App do
  
  before :all do
    @app = Pagoda::Command::App.new({},{},['name'])
  end

  it "Should error if no apps are found" do
    @app.client.stub(:app_list).and_return({})
    @app.should_receive(:error).with(["looks like you haven't launched any apps", "type 'pagoda create' to create this project on pagodabox"])
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
      _id: "4e8cabecbb71f99d10000043",
      name: "myapp",
      ssh: true,
      owner: {
        _id:"4e8c78d6bb71f99b33000003",
        email: "lyon@delorum.com",
        username: "lyon"
        },
      collaborators:[{_id: "4e8c78d6bb71f99b33000003",email: "lyon@delorum.com",username: "lyon"}]
    }
    @app.client.should_receive(:app_info).with("name").and_return(response)
    @app.should_receive(:display).with(no_args).exactly(5).times
    @app.should_receive(:display).with("INFO - myapp")
    @app.should_receive(:display).with("//////////////////////////////////")
    @app.should_receive(:display).with("name        :  myapp")
    @app.should_receive(:display).with("clone url   :  git@pagodabox.com:4e8cabecbb71f99d10000043.git")
    @app.should_receive(:display).with("owner")
    @app.should_receive(:display).with("   username :  lyon")
    @app.should_receive(:display).with("   email    :  lyon@delorum.com")
    @app.should_receive(:display).with("collaborators")
    @app.should_receive(:display).with("   username :  lyon")
    @app.should_receive(:display).with("   email    :  lyon@delorum.com")
    @app.should_receive(:display).with("ssh_portal  :  enabled")
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