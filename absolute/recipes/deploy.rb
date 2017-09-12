#
# Cookbook:: absolute
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info("Absolute application deployment script.")

docker_service 'default' do
  Chef::Log.info('Create and start docker service.')
  action [:create, :start]
end

docker_registry 'https://966390130392.dkr.ecr.us-east-1.amazonaws.com/' do
  username 'AWS'
  password ''
end

docker_network 'galaxy_network' do
  subnet '192.168.0.0/24'
  gateway '192.168.0.1'
  action :create
end

docker_image 'plutonet/absolute' do
  Chef::Log.info('Pulling absolute docker image.')
  action :pull
end

docker_image 'plutonet/nginx' do
  Chef::Log.info('Pulling nginx docker image for absolute.')
  action :pull
end

docker_container 'absolute-cntnr' do
  Chef::Log.info('Deploying absolute servlet.')

  repo 'plutonet/absolute'
  port '8080:8080'
  network_mode 'galaxy_network'
  action :run
end

docker_container 'nginx-cntnr' do
  Chef::Log.info('Deploying nginx/.')

  repo 'plutonet/nginx'
  port '80:80'
  port '443:443'
  network_mode 'galaxy_network'
  action :run
end
