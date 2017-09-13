#
# Cookbook:: absolute
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Absolute application deployment script.')

node[:deploy].each do |application, deploy|
  execute './gradlew build' do
    cwd "#{deploy[:deploy_to]}/current"
    user 'deploy'
    command './gradlew build'
    action :run
  end
end

service 'nginx' do
  action :start
end
