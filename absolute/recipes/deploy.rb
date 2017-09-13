#
# Cookbook:: absolute
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Absolute application deployment script.')

execute 'gradle build' do
  cwd release_path
  user 'deploy'
  command './gradlew build'
  action :run
end
