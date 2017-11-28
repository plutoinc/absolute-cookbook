#
# Cookbook:: absolute
# Recipe:: run_service
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Starting application...')
service 'absolute' do
  action :restart
end
