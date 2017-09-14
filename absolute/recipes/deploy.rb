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
  command './gradlew build --debug'
  action :run
end

Chef::Log.info('Starting nginx...')
service 'nginx' do
  action :start
end

Chef::Log.info('Starting application...')
execute 'rm -f /etc/init.d/absolute' do
  command 'rm -f /etc/init.d/absolute'
  user 'root'
  action :run
end

file "#{app_path}/build/libs/absolute-0.0.1.conf" do
  content 'JAVA_OPTS=-Dspring.profiles.active=dev'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'ln -s build/libs/absolute-0.0.1.jar /etc/init.d/absolute' do
  cwd app_path
  user 'root'
  command "ln -s #{app_path}/build/libs/absolute-0.0.1.jar /etc/init.d/absolute"
  action :run
end

service 'absolute' do
  action :start
end
