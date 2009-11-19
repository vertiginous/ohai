#
# Author:: James Gartrell (<jgartrel@gmail.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
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

provides "hostname", "fqdn"

host = WMI::Win32_ComputerSystem.find(:first)

hostname "#{host.Name}"

if host.Domain.empty?
  Ohai::Log.debug("WMI::Win32_ComputerSystem#Domain is empty, probably no domain is set")
  return nil
else
  fqdn "#{host.Name}.#{host.Domain}"
end