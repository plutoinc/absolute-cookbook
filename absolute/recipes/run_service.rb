#
# Cookbook:: absolute
# Recipe:: run_service
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Starting application...')
service 'absolute' do
  action :restart
end

Chef::Log.info('Starting nginx...')
service 'nginx' do
  action :restart
end
