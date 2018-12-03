namespace :typo3 do
  namespace :cms do
    namespace :cli do
      task 'break_after_one_run' do |_, args|
        capture_typo3_console_in_path_in_loop release_path, 3, args.extra do |output|
          puts output
          false
        end
      end
    end
  end
end

before 'deploy:publishing', 'typo3:cms:cli:break_after_one_run' # with this release_path is defined for the rake task during runtime
