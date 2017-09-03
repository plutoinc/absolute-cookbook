#
# Cookbook:: geth
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_service 'default' do
  action [:create, :start]
end

docker_image 'ethereum/client-go' do
  action :pull
end
