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

require 'ruby-wmi'
require File.join(File.dirname(__FILE__), '..', '..', '..', '/spec_helper.rb')

describe Ohai::System, "Windows plugin uptime" do
  before(:each) do
    @ohai = Ohai::System.new    
    @ohai.stub!(:require_plugin).and_return(true)
    @ohai[:os] = "windows"
    @ohai._require_plugin("uptime")
    @wmi = mock('WIN32OLE')
    WMI::Win32_PerfFormattedData_PerfOS_System.should_receive(:find).with(:first).and_return(@wmi)
    @wmi.should_receive(:SystemUpTime).any_number_of_times.and_return("18423")
  end
 
  it "should set uptime_seconds to uptime" do
    @ohai._require_plugin("windows::uptime")
    @ohai[:uptime_seconds].should == 18423
  end
  
  it "should set uptime to a human readable date" do
    @ohai._require_plugin("windows::uptime")
    @ohai[:uptime].should == "5 hours 07 minutes 03 seconds"
  end
  
end