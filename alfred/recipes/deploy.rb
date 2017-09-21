#
# Cookbook:: alfred
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

Chef::Log.info('Alfred application deployment script.')

app = search('aws_opsworks_app')[1]
app_path = "/srv/#{app['shortname']}"
app_envar = app['environment']
app_profile = app_envar['SPRING_PROFILE']

Chef::Log.info("Clonning repository from github into #{app_path}.")
git app_path do
  repository app['app_source']['url']
  revision app['app_source']['revision']
  enable_submodules true
  action :sync
end

Chef::Log.info('Writing properties file.')
template "#{app_path}/src/main/resources/application-#{app_profile}.properties" do
  source 'application_properties.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    envar: app_envar,
    aws_access_key: node['PLUTO_AWS_ACCESS_KEY'],
    aws_secret_key: node['PLUTO_AWS_SECRET_KEY'],
    aws_region: node['PLUTO_AWS_REGION'],
    aws_s3_bucket_name: node['PLUTO_AWS_S3_BUCKET_NAME']
  )
  action :create
end

Chef::Log.info('Building the application using gradle.')
execute './gradlew build' do
  cwd app_path
  user 'root'
  command './gradlew build --debug'
  action :run
end

execute 'rm -f /etc/init.d/alfred' do
  command 'rm -f /etc/init.d/alfred'
  user 'root'
  action :run
end

file "#{app_path}/build/libs/alfred-0.0.1.conf" do
  content "JAVA_OPTS=-Dspring.profiles.active=#{app_profile}"
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

execute 'ln -s build/libs/alfred-0.0.1.jar /etc/init.d/alfred' do
  cwd app_path
  user 'root'
  command "ln -s #{app_path}/build/libs/alfred-0.0.1.jar /etc/init.d/alfred"
  action :run
end

Chef::Log.info('Configuring nginx...')
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
