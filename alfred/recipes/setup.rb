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
git s3fs_fuse_path do
  repository 'https://github.com/s3fs-fuse/s3fs-fuse'
  enable_submodules true
  action :sync
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
