require 'spec_helper'

describe Pagoda::Runner do

  it "attempts to run an interval" do
    Pagoda::Runner.should_receive(:run_internal).with("command", ["arg1",'arg2']).once
    Pagoda::Runner.go("command",["arg1",'arg2'])
  end

  it "catches bad commands" do
    Pagoda::Runner.stub(:run_internal).and_raise Pagoda::Runner::InvalidCommand
    Pagoda::Runner.should_receive(:error).once
    Pagoda::Runner.go("command",["arg1",'arg2'])
  end

  it "correctly resolves commands" do
    class Pagoda::Command::Test; end
    class Pagoda::Command::Test::Multiple; end
    class Pagoda::Command::Help; end

    Pagoda::Runner.parse("foo").should == [ Pagoda::Command::App, :foo ]
    Pagoda::Runner.parse("test").should == [ Pagoda::Command::Test, :index ]
    Pagoda::Runner.parse("test:foo").should == [ Pagoda::Command::Test, :foo   ]
    Pagoda::Runner.parse("test:multiple:foo").should == [ Pagoda::Command::Test::Multiple, :foo ]
  end 

  it "handles invalid commands" do
    class Pagoda::Command::InvalidCommandTest
      def self.trigger
        raise Pagoda::Runner::InvalidCommand
      end
    end

  end

  it "handles client internal server errors" do
    class Pagoda::Command::InternalServerErrorTest
      def self.trigger
        raise Pagoda::Client::InternalServerError.new("wang chung")
      end
    end
  end

  it "handles kill signal interupts" do
    class Pagoda::Command::InteruptTest
      def self.trigger
        raise Interrupt.new
      end
    end
    
  end


end
