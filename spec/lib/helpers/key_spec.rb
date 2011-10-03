require 'spec_helper'
require 'pagoda/cli/helpers'

describe Pagoda::Command::Key do

  before :all do
    @key = Pagoda::Command::Key.new({},{},[])
  end

  it "will send a valid key file" do
    @key.client.should_receive(:user_add_key)
    @key.stub(:display)
    @key.send_key_file("#{File.expand_path("~")}/.ssh/id_rsa.pub")
  end

  it "attempts to retrieve a file and send it if given a fliename" do
    good_file = Pagoda::Command::Key.new({},{:file => "#{File.expand_path("~")}/.ssh/id_rsa.pub"},[])
    good_file.should_receive(:send_key_file).with("#{File.expand_path("~")}/.ssh/id_rsa.pub")
    good_file.get_key
  end

  it "fails a file check on get_key " do
    bad_file = Pagoda::Command::Key.new({},{:file => "/fake/file.pub"},[])
    bad_file.should_receive(:error).with("file given '/fake/file.pub' does not exist")
    bad_file.get_key
  end

  it "will try gathering the key files if none are specified" do
    @key.stub(:display)
    @key.should_receive(:send_key_file).with("#{File.expand_path("~")}/.ssh/id_rsa.pub")
    @key.get_key
  end

  it "will generagte a key for the user and push that key to pagodabox" do
    @key.stub!(:`)
    @key.stub(:display)
    @key.should_receive(:push_existing_key)
    @key.generate_key_and_push
  end


end