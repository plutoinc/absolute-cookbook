#
# Cookbook:: absolute
# Recipe:: configure
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Absolute application configure script.')

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

service 'nginx' do
  action :restart
end
