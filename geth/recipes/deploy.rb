#
# Cookbook:: geth
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_container 'geth' do
  Chef::Log.info('Deploying geth client.')

  repo 'ethereum/client-go'
  port '8545:8545'
  command '--fast --rinkeby --rpc --rpcaddr "0.0.0.0"'
  action :run
end
