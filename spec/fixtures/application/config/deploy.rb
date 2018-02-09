set :application, 'dkdeploy_app'
set :composer_default_arguments, fetch(:composer_default_arguments) + ['-d=htdocs/']

SSHKit.config.command_map.prefix[:compass].push 'bundle exec'
SSHKit.config.command_map.prefix[:chown].push 'sudo'
SSHKit.config.command_map.prefix[:chgrp].push 'sudo'
SSHKit.config.command_map.prefix[:chmod].push 'sudo'
SSHKit.config.command_map[:composer] = 'vendor/composer.phar'

after 'deploy:updated', 'typo3:cms:setup_additional_configuration'
after 'deploy:updated', 'file_access:set_permissions_of_release_path'
after 'deploy:updated', 'file_access:set_permissions_of_shared_path'
after 'deploy:updated', 'file_access:set_custom_access'
