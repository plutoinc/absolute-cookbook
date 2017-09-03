#
# Cookbook:: geth
# Recipe:: undeploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

docker_container 'geth' do
  action :stop
end