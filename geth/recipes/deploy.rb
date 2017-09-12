#
# Cookbook:: geth
# Recipe:: deploy
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

docker_container 'geth' do
  Chef::Log.info('Deploying geth client.')

  repo 'ethereum/client-go'
  port '30303:30303'
  port '8545:8545'
  command '--fast --rinkeby --rpc --rpcaddr "0.0.0.0"'
  action :run
end
