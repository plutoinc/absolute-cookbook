#
# Cookbook:: alfred
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

packages_to_install = [
  'java-1.8.0-openjdk-devel',
  'git',
  'nginx',
  'gcc',
  'libstdc++-devel',
  'gcc-c++',
  'fuse',
  'fuse-devel',
  'curl-devel',
  'libxml2-devel',
  'mailcap',
  'automake',
  'openssl-devel',
]
packages_to_remove = ['java-1.7.0-openjdk']

packages_to_install.each do |pkg|
  package pkg do
    Chef::Log.info("Installing #{pkg}...")
    action :install
  end
end

packages_to_remove.each do |pkg|
  package pkg do
    Chef::Log.info("Uninstalling #{pkg}...")
    action :remove
  end
end

s3fs_fuse_path = '/srv/pkg/s3fs-fuse'

Chef::Log.info("Clonning s3fs-fuse repository from github into #{s3fs_fuse_path}.")
directory '/srv/pkg' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

git s3fs_fuse_path do
  repository 'https://github.com/s3fs-fuse/s3fs-fuse'
  enable_submodules true
  action :sync
  user 'root'
end

Chef::Log.info('Installing s3fs-fuse')
bash 'installing_s3fs-fuse' do
  cwd s3fs_fuse_path
  user 'root'
  group 'root'
  code <<-EOH
  ./autogen.sh
  ./configure --prefix=/usr --with-openssl
  make
  make install
  EOH
  action :run
end

Chef::Log.info("Saving credential into #{node['PLUTO_S3FS_PASSWD_PATH']}")
directory '/srv/aws' do
  not_if { ::File.directory?(File.dirname(node['PLUTO_S3FS_PASSWD_PATH'])) }
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

file node['PLUTO_S3FS_PASSWD_PATH'] do
  content "#{node['PLUTO_AWS_ACCESS_KEY']}:#{node['PLUTO_AWS_SECRET_KEY']}"
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

Chef::Log.info("Mounting s3 bucket into #{node['PLUTO_BUCKET_MOUNT_PATH']}")
directory node['PLUTO_BUCKET_MOUNT_PATH'] do
  not_if { ::File.directory?(node['PLUTO_BUCKET_MOUNT_PATH']) }
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'making s3fs connection' do
  user 'root'
  command "s3fs #{node['PLUTO_AWS_S3_BUCKET_NAME']} #{node['PLUTO_BUCKET_MOUNT_PATH']} -o passwd_file=#{node['PLUTO_S3FS_PASSWD_PATH']}"
  action :run
end
