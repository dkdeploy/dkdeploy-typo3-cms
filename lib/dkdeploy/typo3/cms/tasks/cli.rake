require 'json'
require 'dkdeploy/typo3/cms/helpers/cli'

include Capistrano::DSL
include Dkdeploy::Typo3::Cms::Helpers::Cli

namespace :typo3 do
  namespace :cms do
    namespace :cli do
      desc 'Execute TYPO3 cli task'
      task :run do |task, args|
        typo3_cli(args.extras)

        # Reenable Task to allow multiple invokation
        task.reenable
      end

      desc 'Execute a typo3_console task'
      task :typo3_console do |task, args|
        typo3_console(args.extras)

        # Reenable Task to allow multiple invokation
        task.reenable
      end

      desc 'Uploads wrapper script to initialize PHP with environment variables'
      task :upload_wrapper do
        path_to_typo_cms_cli_dispatch = File.join release_path, 'typo3_cms_cli_dispatch.sh'
        path_to_cli_dispatch = File.join release_path, 'typo3', 'cli_dispatch.phpsh'

        bash_path = SSHKit.config.command_map[:bash]
        wrapper_file_content = "#!#{bash_path}\n"
        fetch(:typo3_environment_cli).each do |variable_name, variable_value|
          wrapper_file_content << "#{variable_name.to_s.upcase}='#{variable_value}' "
        end

        php_interpreter_path = SSHKit.config.command_map[:php]
        wrapper_file_content << "#{php_interpreter_path} #{path_to_cli_dispatch} $@\n"
        on release_roles :backend do
          upload! StringIO.new(wrapper_file_content), path_to_typo_cms_cli_dispatch
        end
      end
    end
  end
end
