#
# Cookbook:: absolute
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'yum-update' do
  command 'yum update'
  user 'root'
  action :run
end
