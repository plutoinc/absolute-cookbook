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

Chef::Log.info('Stopping nginx...')
service 'nginx' do
  action :stop
end
