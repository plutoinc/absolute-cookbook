#
# Cookbook:: geth
# Recipe:: shutdown
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_image 'ethereum/client-go' do
  Chef::Log.info('Shutting down geth client.')

  action :remove
end
