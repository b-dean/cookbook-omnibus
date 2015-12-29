#
# Cookbook Name:: omnibus
# Recipe:: _omnibus_toolchain
#
# Copyright 2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unless omnibus_toolchain_enabled?
  log 'omnibus_toolchain_not_enabled' do
    message 'Deciding not to install Omnibus Toolchain (package)'
  end
  return
end

if solaris_10?
  # create a nocheck file for automated install
  file '/var/sadm/install/admin/auto-install' do
    content <<-EOH.gsub(/^\s{6}/, '')
      mail=
      instance=overwrite
      partial=nocheck
      runlevel=nocheck
      idepend=nocheck
      space=ask
      setuid=nocheck
      conflict=nocheckit
      action=nocheck
      basedir=default
    EOH
    owner 'root'
    group 'root'
    mode '0444'
  end
end

package_path = File.join(Chef::Config[:file_cache_path], File.basename(node['omnibus']['toolchain_url']))
version      = node['omnibus']['toolchain_version']

remote_file package_path do
  source node['omnibus']['toolchain_url']
  action :create_if_missing
end

package node['omnibus']['toolchain_name'] do
  provider Chef::Provider::Package::Yum if nexus?
  source package_path
  version version
  options '-a auto-install' if solaris2?
end

user node['omnibus']['build_user'] do
  shell "/opt/#{node['omnibus']['toolchain_name']}/embedded/bin/bash"
  action :modify
end
