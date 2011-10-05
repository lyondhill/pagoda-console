require 'spec_helper'

describe Pagoda::Command::Tunnel do
  
  before :all do
    @tunnel = Pagoda::Command::Tunnel.new({:username => "user", :password => "pass", :app => "application"},{},["ginger"])
  end

  it "will attempt to run the tunnel if it has all the correct credentials" do
    @tunnel.client.stub(:component_info).and_return({:tunnelable => true, :_type => "mysql", :_id => "theid142", :app_id => "appID"})
    guy = Pagoda::Tunnel.new("mysql", "user", "pass","application", "theid142")
    guy.stub(:start).and_return false
    Pagoda::Tunnel.should_receive(:new).with("mysql", "user", "pass","appID", "theid142").and_return(guy)
    @tunnel.run
  end

  it "errors when the component is not tunnelable" do
    @tunnel.client.stub(:component_info).and_return({:tunnelable => false, :type => "mysql", :_id => "theid142"})
    @tunnel.should_receive(:error).with("Either the component is not tunnelable or you do not have access")
    @tunnel.run
  end

  it "errors if the component doesnt exist or there ins an api problem" do
    @tunnel.client.stub(:component_info).and_raise "dont you dare"
    @tunnel.should_receive(:error).with("Done Brokedon! Either the component does not exist or it is not tunnelable")
    @tunnel.run
  end


end