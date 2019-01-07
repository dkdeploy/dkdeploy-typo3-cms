# frozen_string_literal: true

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
    end
  end
end
