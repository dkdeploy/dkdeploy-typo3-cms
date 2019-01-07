# frozen_string_literal: true

namespace :typo3 do
  namespace :cms do
    namespace :cli do
      # desc 'Execute TYPO3 cli task in Specific directory'
      # task :run_in_release_path do |task, args| # First agument is directory
      task 'run_in_release_path' do |task, args|
        typo3_cli_in_path(release_path, args.extras)
        # Reenable Task to allow multiple invokation
        task.reenable
      end
    end
  end
end

set :path_to_typo3_cli, File.join('catalog', 'variable_injection_test.phpsh')

set :typo3_environment_cli, {
  CUSTOM_VARIABLE: 1
}

before 'deploy:publishing', 'typo3:cms:cli:run_in_release_path' # with this release_path is defined for the rake task during runtime
