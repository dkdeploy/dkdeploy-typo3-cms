# frozen_string_literal: true

namespace :typo3 do
  namespace :cms do
    namespace :cli do
      task 'break_after_three_runs' do |_, args|
        capture_typo3_console_in_path_in_loop release_path, 3, args.extra do |output|
          puts output
          true
        end
      end
    end
  end
end

before 'deploy:publishing', 'typo3:cms:cli:break_after_three_runs' # with this release_path is defined for the rake task during runtime
