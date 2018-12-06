require 'pathname'
require 'dkdeploy/typo3/cms/i18n'
require 'dkdeploy/helpers/common'

include Dkdeploy::Helpers::Common

namespace :typo3 do
  namespace :cms do
    namespace :typoscript do
      desc "Uploads TypoScript config files from local paths prefixed by variable 'copy_source'"
      task :upload_configs, :copy_source, :typoscript_config_paths, :typoscript_config_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_config_paths, 'tasks.typoscript.config_paths') { |question| question.default = '' }
        config_file = ask_variable(args, :typoscript_config_file, 'tasks.typoscript.config_file') { |question| question.default = 'config.txt' }

        paths.each do |path|
          local_path         = File.join(prefix, path)
          local_config_file  = File.join(local_path, config_file)
          remote_path        = File.join(current_path, remote, path)
          remote_config_file = File.join(remote_path, config_file)

          unless File.exist? local_config_file
            run_locally do
              info I18n.t('tasks.typoscript.skipping', file_or_directory: local_config_file, scope: :dkdeploy)
            end
            next
          end

          on release_roles :app do
            execute :mkdir, '-p', remote_path
            info I18n.t('tasks.typoscript.uploading', local_file: local_config_file, remote_file: remote_config_file, scope: :dkdeploy)
            upload! local_config_file, remote_config_file
            info I18n.t('tasks.typoscript.uploaded', local_file: local_config_file, remote_file: remote_config_file, scope: :dkdeploy)
          end
        end
      end

      desc "Uploads PageTS files from local paths prefixed by variable 'copy_source'"
      task :upload_pagets, :copy_source, :typoscript_pagets_paths, :typoscript_pagets_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_pagets_paths, 'tasks.typoscript.pagets_paths') { |question| question.default = '' }
        pagets_file = ask_variable(args, :typoscript_pagets_file, 'tasks.typoscript.pagets_file') { |question| question.default = 'PageTS.txt' }

        paths.each do |path|
          local_path         = File.join(prefix, path)
          local_pagets_file  = File.join(local_path, pagets_file)
          remote_path        = File.join(current_path, remote, path)
          remote_pagets_file = File.join(remote_path, pagets_file)

          unless File.exist? local_pagets_file
            run_locally do
              info I18n.t('tasks.typoscript.skipping', file_or_directory: local_pagets_file, scope: :dkdeploy)
            end
            next
          end

          on release_roles :app do
            execute :mkdir, '-p', remote_path
            info I18n.t('tasks.typoscript.uploading', local_file: local_pagets_file, remote_file: remote_pagets_file, scope: :dkdeploy)
            upload! local_pagets_file, remote_pagets_file
            info I18n.t('tasks.typoscript.uploaded', local_file: local_pagets_file, remote_file: remote_pagets_file, scope: :dkdeploy)
          end
        end
      end

      desc "Uploads UserTS files from local paths prefixed by variable 'copy_source'"
      task :upload_userts, :copy_source, :typoscript_userts_paths, :typoscript_userts_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_userts_paths, 'tasks.typoscript.userts_paths') { |question| question.default = '' }
        userts_file = ask_variable(args, :typoscript_userts_file, 'tasks.typoscript.userts_file') { |question| question.default = 'UserTS.txt' }

        paths.each do |path|
          local_path         = File.join(prefix, path)
          local_userts_file  = File.join(local_path, userts_file)
          remote_path        = File.join(current_path, remote, path)
          remote_userts_file = File.join(remote_path, userts_file)

          unless File.exist? local_userts_file
            run_locally do
              info I18n.t('tasks.typoscript.skipping', file_or_directory: local_userts_file, scope: :dkdeploy)
            end
            next
          end

          on release_roles :app do
            execute :mkdir, '-p', remote_path
            info I18n.t('tasks.typoscript.uploading', local_file: local_userts_file, remote_file: remote_userts_file, scope: :dkdeploy)
            upload! local_userts_file, remote_userts_file
            info I18n.t('tasks.typoscript.uploaded', local_file: local_userts_file, remote_file: remote_userts_file, scope: :dkdeploy)
          end
        end
      end

      desc 'Uploads all config files from given base path'
      task :upload_config_from_base_path, :copy_source, :typoscript_config_base_path, :typoscript_config_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_config_base_path, 'tasks.typoscript.typoscript_config_base_path') { |question| question.default = '.' }
        config_file = ask_variable(args, :typoscript_config_file, 'tasks.typoscript.config_file') { |question| question.default = 'config.txt' }

        config_files = Dir[File.join(prefix, base_path, '**', config_file).to_s].map { |path_for_config_file| Pathname.new(path_for_config_file).relative_path_from(Pathname.new(prefix)).dirname.to_s }

        next if config_files.empty?

        set :copy_source, prefix
        set :remote_web_root_path, remote
        set :typoscript_config_paths, config_files
        set :typoscript_config_file, config_file
        invoke 'typo3:cms:typoscript:upload_configs'
      end

      desc 'Uploads all PageTS files from given base path'
      task :upload_pagets_from_base_path, :copy_source, :typoscript_pagets_base_path, :typoscript_pagets_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_pagets_base_path, 'tasks.typoscript.typoscript_pagets_base_path') { |question| question.default = '.' }
        pagets_file = ask_variable(args, :typoscript_pagets_file, 'tasks.typoscript.pagets_file') { |question| question.default = 'PageTS.txt' }

        pagets_files = Dir[File.join(prefix, base_path, '**', pagets_file).to_s].map { |path_for_pagets_file| Pathname.new(path_for_pagets_file).relative_path_from(Pathname.new(prefix)).dirname.to_s }
        next if pagets_files.empty?

        set :copy_source, prefix
        set :remote_web_root_path, remote
        set :typoscript_pagets_paths, pagets_files
        set :typoscript_pagets_file, pagets_file
        invoke 'typo3:cms:typoscript:upload_pagets'
      end

      desc 'Uploads all UserTS files from given base path'
      task 'upload_userts_from_base_path', :copy_source, :typoscript_userts_base_path, :typoscript_userts_file do |_, args|
        prefix      = ask_variable(args, :copy_source, 'tasks.typoscript.copy_source') { |question| question.default = 'htdocs' }
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_userts_base_path, 'tasks.typoscript.typoscript_userts_base_path') { |question| question.default = '.' }
        userts_file = ask_variable(args, :typoscript_userts_file, 'tasks.typoscript.userts_file') { |question| question.default = 'UserTS.txt' }

        userts_files = Dir[File.join(prefix, base_path, '**', userts_file).to_s].map { |path_for_userts_file| Pathname.new(path_for_userts_file).relative_path_from(Pathname.new(prefix)).dirname.to_s }
        next if userts_files.empty?

        set :copy_source, prefix
        set :remote_web_root_path, remote
        set :typoscript_userts_paths, userts_files
        set :typoscript_userts_file, userts_file
        invoke 'typo3:cms:typoscript:upload_userts'
      end

      desc 'Merge remote TypoScript config files'
      task :merge_configs, :typoscript_config_paths, :typoscript_config_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_config_paths, 'tasks.typoscript.config_paths')
        config_file = ask_variable(args, :typoscript_config_file, 'tasks.typoscript.config_file') { |question| question.default = 'config.txt' }

        paths.each do |path|
          path = File.join(release_path, remote, path)

          target_config_file_with_stage_name = config_file.split('.').join(".#{fetch(:stage)}.")
          source_config_file = File.join(path, 'Stages', target_config_file_with_stage_name)
          target_config_file = File.join(path, config_file)

          on release_roles :app do
            unless test "[ -d #{path} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: path, scope: :dkdeploy)
              next
            end

            unless test "[ -f #{source_config_file} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: source_config_file, scope: :dkdeploy)
              next
            end

            execute :echo, "''", '>>', target_config_file
            execute :cat, source_config_file, '>>', target_config_file
            info I18n.t('tasks.typoscript.merged', source_file: source_config_file, target_file: target_config_file, scope: :dkdeploy)
          end
        end
      end

      desc 'Merge remote PageTS files'
      task :merge_pagets, :typoscript_pagets_paths, :typoscript_pagets_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_pagets_paths, 'tasks.typoscript.pagets_paths')
        pagets_file = ask_variable(args, :typoscript_pagets_file, 'tasks.typoscript.pagets_file') { |question| question.default = 'PageTS.txt' }

        paths.each do |path|
          path = File.join(release_path, remote, path)

          target_pagets_file_with_stage_name = pagets_file.split('.').join(".#{fetch(:stage)}.")
          source_pagets_file = File.join(path, 'Stages', target_pagets_file_with_stage_name)
          target_pagets_file = File.join(path, pagets_file)

          on release_roles :app do
            unless test "[ -d #{path} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: path, scope: :dkdeploy)
              next
            end

            unless test "[ -f #{source_pagets_file} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: source_pagets_file, scope: :dkdeploy)
              next
            end

            execute :echo, "''", '>>', target_pagets_file
            execute :cat, source_pagets_file, '>>', target_pagets_file
            info I18n.t('tasks.typoscript.merged', source_file: source_pagets_file, target_file: target_pagets_file, scope: :dkdeploy)
          end
        end
      end

      desc 'Merge remote UserTS files'
      task :merge_userts, :typoscript_userts_paths, :typoscript_userts_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        paths       = ask_array_variable(args, :typoscript_userts_paths, 'tasks.typoscript.userts_paths')
        userts_file = ask_variable(args, :typoscript_userts_file, 'tasks.typoscript.userts_file') { |question| question.default = 'UserTS.txt' }

        paths.each do |path|
          path = File.join(release_path, remote, path)

          target_userts_file_with_stage_name = userts_file.split('.').join(".#{fetch(:stage)}.")
          source_userts_file = File.join(path, 'Stages', target_userts_file_with_stage_name)
          target_userts_file = File.join(path, userts_file)

          on release_roles :app do
            unless test "[ -d #{path} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: path, scope: :dkdeploy)
              next
            end

            unless test "[ -f #{source_userts_file} ]"
              info I18n.t('tasks.typoscript.skipping', file_or_directory: source_userts_file, scope: :dkdeploy)
              next
            end

            execute :echo, "''", '>>', target_userts_file
            execute :cat, source_userts_file, '>>', target_userts_file
            info I18n.t('tasks.typoscript.merged', source_file: source_userts_file, target_file: target_userts_file, scope: :dkdeploy)
          end
        end
      end

      desc 'Merge all remote config files for a given base path'
      task :merge_config_in_base_path, :typoscript_config_base_path, :typoscript_config_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_config_base_path, 'tasks.typoscript.typoscript_config_base_path') { |question| question.default = '.' }
        config_file = ask_variable(args, :typoscript_config_file, 'tasks.typoscript.config_file') { |question| question.default = 'config.txt' }

        list_of_files = ''
        target_config_file_with_stage_name = config_file.split('.').join(".#{fetch(:stage)}.")
        on primary :app do
          list_of_files = capture :find, File.join(release_path, remote, base_path), '-type f', "-name '#{target_config_file_with_stage_name}'"
        end

        next if list_of_files.empty?
        config_files = list_of_files.split.map { |file| Pathname.new(file).relative_path_from(Pathname.new(release_path)).dirname.dirname.to_s }

        set :typoscript_config_paths, config_files
        set :typoscript_config_file, config_file
        invoke 'typo3:cms:typoscript:merge_configs'
      end

      desc 'Merge all remote PageTS files for a given base path'
      task :merge_pagets_in_base_path, :typoscript_pagets_base_path, :typoscript_pagets_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_pagets_base_path, 'tasks.typoscript.typoscript_pagets_base_path') { |question| question.default = '.' }
        pagets_file = ask_variable(args, :typoscript_pagets_file, 'tasks.typoscript.pagets_file') { |question| question.default = 'PageTS.txt' }

        list_of_files = ''
        target_pagets_file_with_stage_name = pagets_file.split('.').join(".#{fetch(:stage)}.")
        on primary :app do
          list_of_files = capture :find, File.join(release_path, remote, base_path), '-type f', "-name '#{target_pagets_file_with_stage_name}'"
        end

        next if list_of_files.empty?
        pagets_files = list_of_files.split.map { |file| Pathname.new(file).relative_path_from(Pathname.new(release_path)).dirname.dirname.to_s }

        set :typoscript_pagets_paths, pagets_files
        set :typoscript_pagets_file, pagets_file
        invoke 'typo3:cms:typoscript:merge_pagets'
      end

      desc 'Merge all remote UserTS files for a given bbase path'
      task :merge_userts_in_base_path, :typoscript_userts_base_path, :typoscript_userts_file do |_, args|
        remote      = fetch(:remote_web_root_path, '.')
        base_path   = ask_variable(args, :typoscript_userts_base_path, 'tasks.typoscript.typoscript_userts_base_path') { |question| question.default = '.' }
        userts_file = ask_variable(args, :typoscript_userts_file, 'tasks.typoscript.userts_file') { |question| question.default = 'UserTS.txt' }

        list_of_files = ''
        target_userts_file_with_stage_name = userts_file.split('.').join(".#{fetch(:stage)}.")
        on primary :app do
          list_of_files = capture :find, File.join(release_path, remote, base_path), '-type f', "-name '#{target_userts_file_with_stage_name}'"
        end

        next if list_of_files.empty?
        userts_files = list_of_files.split.map { |file| Pathname.new(file).relative_path_from(Pathname.new(release_path) + remote).dirname.dirname.to_s }

        set :typoscript_userts_paths, userts_files
        set :typoscript_userts_file, userts_file
        invoke 'typo3:cms:typoscript:merge_userts'
      end
    end
  end
end
