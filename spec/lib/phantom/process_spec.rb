require 'spec_helper'
require 'phantom/process'

module Phantom
  describe Process do
    describe :initialization do

      it "should initialize with new" do
        p = Phantom::Process.new(1, 2, "cmd", 4)
        p.pid.should eq 1
        p.memory_usage.should eq 2
        p.command.should eq "cmd"
        p.port.should eq 4
      end

      it "should initialize with string" do
        p = Phantom::Process.from_string("1 2 phantomjs rndrme.js 4")
        p.pid.should eq 1
        p.memory_usage.should eq 2
        p.command.should eq "phantomjs rndrme.js 4"
        p.port.should eq 4
      end

      it "should initialize empty" do
        p = Phantom::Process.new
        p.should_not be_nil
      end

    end

    describe :kill do
      it "should send system kill call" do
        p = generate_process
        Utils::Shell.should_receive(:execute).with("kill #{p.pid}")
        p.kill
      end
    end

    describe :start do
      it "should send system kill call" do
        p = generate_process
        Utils::Shell.should_receive(:execute).with(p.send(:start_command))
        p.start
      end
    end

    describe :inspect do
      it "should present all data in string" do
        p = generate_process
        "#{p}".should eq "pid: #{p.pid}, port: #{p.port}, memory_usage: #{p.memory_usage}, command: #{p.command}"
      end
    end
  end
end
