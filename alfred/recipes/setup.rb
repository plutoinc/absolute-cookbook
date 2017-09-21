#
# Cookbook:: alfred
# Recipe:: setup
#
# Copyright:: 2017, The Authors, All Rights Reserved.

packages_to_install = [
  'java-1.8.0-openjdk-devel',
  'git',
  'nginx',
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
