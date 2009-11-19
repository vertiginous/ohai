#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2008 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require File.join(File.dirname(__FILE__), '..', '..', '..', '/spec_helper.rb')
require 'ruby-wmi'

describe Ohai::System, "Windows hostname plugin" do
  before(:each) do    
    @ohai = Ohai::System.new
    @ohai.stub!(:require_plugin).and_return(true)
    @ohai[:os] = "windows"
    @wmi = mock('WIN32OLE')
    WMI::Win32_ComputerSystem.should_receive(:find).with(:first).and_return(@wmi)
    @wmi.should_receive(:Name).any_number_of_times.and_return("katie")
  end

  it "should get the hostname value from WMI" do
    @ohai._require_plugin("windows::hostname")
    @ohai.hostname.should == "katie"
  end
  
  it "should get the fqdn value from WMI" do
    @wmi.should_receive(:Domain).any_number_of_times.and_return("bethell")
    @ohai._require_plugin("windows::hostname")
    @ohai.fqdn.should == "katie.bethell"
  end
  
  describe "when domain name is unset" do 
    before(:each) do
      @wmi.should_receive(:Domain).any_number_of_times.and_return(nil)
    end

    it "should not raise an error" do
      lambda { @ohai._require_plugin("windows::hostname") }.should_not raise_error
    end

    it "should not set fqdn" do
      @ohai._require_plugin("windows::hostname")
      @ohai.fqdn.should == nil
    end

  end
    
end

