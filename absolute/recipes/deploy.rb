#
# Cookbook:: absolute
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Absolute application deployment script.')

app = search('aws_opsworks_app').first
app_path = "/srv/#{app['shortname']}"

Chef::Log.info("Clonning repository from github into #{app_path}.")
git app_path do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  enable_submodules true
  action :sync
end

Chef::Log.info('Building the application using gradle.')
execute './gradlew build' do
  cwd app_path
  user 'root'
  command './gradlew build'
  action :run
end

Chef::Log.info('Starting nginx...')
service 'nginx' do
  action :start
end

Chef::Log.info('Starting application...')
execute 'java -jar -Dspring.profiles.active=dev -Djava.security.egd=file:/dev/./urandom -jar build/libs/absolute-0.0.1.jar' do
  cwd app_path
  user 'root'
  command 'java -jar -Dspring.profiles.active=dev -Djava.security.egd=file:/dev/./urandom -jar build/libs/absolute-0.0.1.jar'
  action :run
end
