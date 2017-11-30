#
# Cookbook:: alfred
# Recipe:: undeploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Alfred application undeployment script.')

Chef::Log.info('Stopping application...')
service 'alfred' do
  action :stop
end

Chef::Log.info('Deleting application files...')
file '/etc/init.d/alfred' do
  action :delete
end

directory '/srv/alfred' do
  recursive true
  action :delete
end
