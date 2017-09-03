#
# Cookbook:: geth
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
docker_image 'ethereum/client-go' do
  tag 'alpine'
  action :pull
end

docker_container 'geth' do
  repo 'ethereum/client-go'
  tag 'alpine'
end