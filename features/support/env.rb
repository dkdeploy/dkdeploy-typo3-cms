require 'dkdeploy/test_environment/application'
ssh_config = {}

ssh_key_files = Dir.glob(File.join(Dir.getwd, '.vagrant', 'machines', '**', 'virtualbox', 'private_key'))
unless ssh_key_files.empty?
  # Define generated ssh key files
  ssh_config = { user: 'ubuntu', keys: ssh_key_files }
end

TEST_APPLICATION = Dkdeploy::TestEnvironment::Application.new(File.expand_path('../../../', __FILE__), 'dkdeploy-typo3-cms.dev', ssh_config)
TEST_APPLICATION.mysql_connection_settings = { host: 'dkdeploy-typo3-cms.dev', username: 'root', password: 'ilikerandompasswords' }

# this configuration tricks Bundler into executing another Bundler project with clean enviroment
# The official way via Bundler.with_clean_env did not work properly here
Aruba.configure do |config|
  config.command_runtime_environment = { 'BUNDLE_GEMFILE' => File.join(TEST_APPLICATION.test_app_path, 'Gemfile') }
  config.exit_timeout = 30
end
