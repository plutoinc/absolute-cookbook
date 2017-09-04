#
# Cookbook:: geth
# Recipe:: undeploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_container 'geth' do
  Chef::Log.info('Stopping geth client.')

  action :stop
end