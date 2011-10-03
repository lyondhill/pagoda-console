require 'spec_helper'

describe Pagoda::Command::Tunnel do
  
  before :all do
    @tunnel = Pagoda::Command::Tunnel.new({},{},['-a','app'])
  end

  it "should be able to create a database for the app" do
    Pagoda::Runner.should_receive(:run_internal).with("tunnel:mysql", ['-a','app'])
    @tunnel.index
  end

  it "should be able to retrieve the user name and password" do
    Pagoda::Auth.stub(:user).and_return("user")
    Pagoda::Auth.stub(:password).and_return("password")
    @tunnel.user.should == "user"
    @tunnel.password.should == "password"
  end

  it "should error out if there are no databases" do
    @tunnel.stub(:option_value).and_return false
    @tunnel.stub(:display)
    @tunnel.client.stub(:database_list).and_return([])
    @tunnel.client.stub(:database_exists?).and_return(false)
    @tunnel.stub(:app).and_return("app")
    @tunnel.should_receive(:error).with(["It looks like you don't have any MySQL instances for app","Feel free to add one in the admin panel (10 MB Free)"])
    @tunnel.should_receive(:error).with(["Security exception -","Either the MySQL instance doesn't exist or you are unauthorized"])
    @tunnel.mysql
  end

  it "should error out with more then on database" do
    errors = []
    errors << "Multiple MySQL instances found"
    errors << ""
    errors << "-> katie"
    errors << "-> jane"
    errors << ""
    errors << "Please specify which instance you would like to use."
    errors << ""
    errors << "ex: pagoda tunnel -n katie"
    @tunnel.stub(:option_value).and_return false
    @tunnel.stub(:display)
    @tunnel.client.stub(:database_list).and_return([{:name => "katie"}, {:name => "jane"}])
    @tunnel.client.stub(:database_exists?).and_return(false)
    @tunnel.stub(:app).and_return("app")
    @tunnel.should_receive(:error).with(errors)
    @tunnel.should_receive(:error).with(["Security exception -","Either the MySQL instance doesn't exist or you are unauthorized"])
    @tunnel.mysql
    
  end

  it "will run properly with no errors with the correct data" do
    @tunnel.stub(:option_value).and_return false
    @tunnel.should_receive(:display).with(no_args)
    @tunnel.should_receive(:display).with("+> Authenticating Database Ownership")
    @tunnel.client.stub(:database_list).and_return([{:name => "katie"}])
    @tunnel.client.stub(:database_exists?).and_return(true)
    @tunnel.stub(:app).and_return("app")
    tonz = Pagoda::Tunnel.new(nil,nil,nil,nil,nil)
    tonz.stub(:start)
    Pagoda::Tunnel.stub(:new).and_return(tonz)
    @tunnel.mysql
    
  end


end