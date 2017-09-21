#
# Cookbook:: alfred
# Recipe:: shutdown
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'make s3fs disconnection' do
  user 'root'
  command "unmount #{node['PLUTO_BUCKET_MOUNT_PATH']}"
  action :run
end
