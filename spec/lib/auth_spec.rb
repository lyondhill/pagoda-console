require 'spec_helper'
require 'fakefs'

describe Pagoda::Auth do
  
  it "only allows 3 attempts" do
    Pagoda::Auth.retry_login?.should == true
    Pagoda::Auth.retry_login?.should == true
    Pagoda::Auth.retry_login?.should == false
  end

  it "checks the args for possible Username or Passwords" do
    Pagoda::Auth.check_for_credentials.should == false
    silently {ARGV = ["-u", "username", "--password=passw0rd"]} # Stupid Warning
    Pagoda::Auth.check_for_credentials.should == ["username", "passw0rd"]
  end

  it "seperate out user from credentials" do
    Pagoda::Auth.stub(:credentials).and_return(['User', 'passw0rd'])
    Pagoda::Auth.user.should == "User"
  end

  it "seperate out password from credentials" do
    Pagoda::Auth.stub(:credentials).and_return(['User', 'passw0rd'])
    Pagoda::Auth.password.should == "passw0rd"
  end

  it "should correctly hit each function in credentials" do
    Pagoda::Auth.should_receive(:check_for_credentials).once.and_return(false)
    Pagoda::Auth.should_receive(:read_credentials).once.and_return(false)
    Pagoda::Auth.should_receive(:ask_for_credentials).once.and_return(["use","pas"])
    Pagoda::Auth.should_receive(:save_credentials).once.with(["use","pas"])
    Pagoda::Auth.credentials
  end

  it "writes credentials to the .pagoda/credentails file" do
    Pagoda::Auth.stub(:set_credentials_permissions)
    FakeFS do
      Pagoda::Auth.write_credentials(["username", "password"])
      File.exists?("#{ENV['HOME']}/.pagoda/credentials").should == true
    end
  end

  it "should error out if credetials are not valid" do
    c = Pagoda::Client.new(nil,nil)
    c.stub(:app_list).and_raise("AUTHINGACTION FALIED YOU NUB")
    Pagoda::Client.stub(:new).and_return(c)
    Pagoda::Auth.should_receive(:error).with("Authentication failed")
    Pagoda::Auth.save_credentials(["baduser","password"])
  end

  it "should write credentials if they are valid" do
    c = Pagoda::Client.new(nil,nil)
    c.stub(:app_list).and_return({:appnamesmeothing => "somethingelse"})
    Pagoda::Client.stub(:new).and_return(c)
    Pagoda::Auth.should_receive(:write_credentials).with(["baduser","password"])
    Pagoda::Auth.save_credentials(["baduser","password"])
  end

  it "should be able to read credentials from file" do
    FakeFS do
      Pagoda::Auth.read_credentials.should == ["username", "password"]
    end
  end

  it "deletes credential files" do
    FakeFS do
      Pagoda::Auth.delete_credentials
      File.exists?("#{ENV['HOME']}/.pagoda/credentials").should == false
    end
  end

  it "should return false if credentials dont exist on the machine" do
    FakeFS do
      Pagoda::Auth.read_credentials.should == false
    end
  end



end