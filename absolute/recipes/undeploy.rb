#
# Cookbook:: absolute
# Recipe:: undeploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Absolute application undeployment script.')

Chef::Log.info('Stopping application...')
service 'absolute' do
  action :stop
end
