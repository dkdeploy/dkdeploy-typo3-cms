include Capistrano::DSL

namespace :typo3 do
  namespace :cms do
    namespace :cache do
      desc 'Clear TYPO3 file cache directory'
      task :clear_file_cache do |task|
        on release_roles :app do
          cache_path = File.join release_path, 'typo3temp', 'var', 'Cache'
          execute :rm, '-rf', cache_path if test "[ -d #{cache_path} ]"
        end

        # Reenable Task to allow multiple invokation
        task.reenable
      end
    end
  end
end
