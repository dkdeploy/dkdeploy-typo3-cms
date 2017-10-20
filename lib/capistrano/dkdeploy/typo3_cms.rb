require 'capistrano/dkdeploy/php'

include Capistrano::DSL

# Load dkdeploy tasks
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/typo3.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/typoscript.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/cache.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/cli.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/caretaker_key_management.rake', __FILE__)

namespace :load do
  task :defaults do
    set :typoscript_userts_file, 'UserTS.txt'
    set :typoscript_pagets_file, 'PageTS.txt'
    set :typoscript_config_file, 'config.txt'
    set :create_new_caretaker_keys, 'false'
    set :caretaker_public_key_path, -> { File.join(shared_path, 'config', 'pubkey.pem') }
    set :caretaker_private_key_path, -> { File.join(shared_path, 'config', 'privkey.pem') }
    set :create_caretaker_instance_keys_template, -> { File.join(__dir__, '..', '..', '..', 'vendor', 'create_caretaker_instance_keys.php.erb') }
    set :create_caretaker_instance_keys_path, -> { File.join(shared_path, 'config', 'create_caretaker_instance_keys.php') }
    set :caretaker_instance_keys_path, -> { File.join(shared_path, 'config', 'caretaker_instance_keys.php') }

    # Use custom Composer autoload
    set :typo3_environment_cli, {
      TYPO3_COMPOSER_AUTOLOAD: 1,
      TERM: 'screen-256color'
    }
    # Path to typo3_console. Relative path to typo3_console script
    set :path_to_typo3_console, File.join('bin', 'typo3cms')
    set :path_to_typo3_cli, File.join('bin', 'typo3')

    set :additional_configuration_template, File.join(__dir__, '..', '..', '..', 'vendor', 'AdditionalConfiguration.php.erb')
    set :additional_configuration_files, []

    add_rollback_task('typo3:cms:cache:clear_file_cache')
  end
end
