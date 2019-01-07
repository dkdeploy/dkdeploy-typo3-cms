# frozen_string_literal: true

namespace :typo3 do
  namespace :cms do
    namespace :cli do
      task 'break_after_one_run' do |_, args|
        capture_typo3_cli_in_loop 3, args.extra do |output|
          puts output
          false
        end
      end

      task 'break_after_three_runs' do |_, args|
        capture_typo3_cli_in_loop 3, args.extra do |output|
          puts output
          true
        end
      end
    end
  end
end
