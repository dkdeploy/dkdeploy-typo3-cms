# update apt packages
include_recipe 'apt'

# Create unix user for tests
user 'test-user' do
  action :create
end

group 'test-group' do
  action :create
  append true
  members 'test-user'
end

group 'www-data' do
  action :create
  append true
  members 'ubuntu'
end

# PHP
include_recipe 'php'
include_recipe 'php::module_mysql'

# Apache
include_recipe 'apache2'
include_recipe 'apache2::mod_php'

# install apache2-utils. It is needed for the assets:add_htpasswd task
package 'apache2-utils' do
  action :install
end

mysql_service 'default' do
  port '3306'
  # Need for remote connection
  bind_address '0.0.0.0'
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  password: 'ilikerandompasswords'
}

mysql_database_user 'root' do
  connection mysql_connection_info
  password 'ilikerandompasswords'
  host '%'
  action :create
  privileges [:all]
  action :grant
end

mysql_database 'dkdeploy_typo3_cms' do
  action :create
  # password node['mysql']['server_root_password']
  connection mysql_connection_info
end

directory '/var/www/' do
  owner 'ubuntu' # deployment is done by ubuntu user
  group 'www-data' # apache2 is executed by www-data and needs access to directory
  mode '0770'
  action :create
end
