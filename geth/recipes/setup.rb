#
# Cookbook:: geth
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_service 'default' do
  Chef::Log.info('Create and start docker service.')
  action [:create, :start]
end

docker_image 'ethereum/client-go' do
  Chef::Log.info('Pulling geth client.')
  action :pull
end
