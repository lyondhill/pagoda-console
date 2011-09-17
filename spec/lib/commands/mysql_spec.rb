require 'spec_helper'

describe Pagoda::Command::Mysql do
  
  before :all do
    @mysql = Pagoda::Command::Mysql.new(nil)
    @mysql.stub(:display)
  end

  it "should be able to create a database for the app" do
    @mysql.client.should_receive(:database_create).with("name", "mysql")
    @mysql.stub(:loop_transaction)
    @mysql.create
  end


end