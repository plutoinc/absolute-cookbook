#
# Cookbook:: alfred
# Recipe:: configure
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Alfred application configure script.')

file '/etc/nginx/nginx.conf' do
  action :delete
end

cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
