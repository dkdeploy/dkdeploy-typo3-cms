require 'securerandom'
require 'digest/md5'
require 'dkdeploy/typo3/cms/dsl'
require 'dkdeploy/typo3/cms/i18n'
require 'dkdeploy/helpers/common'
require 'dkdeploy/interaction_handler/password'
require 'phpass'
require 'shellwords'

require 'erb'
require 'dkdeploy/typo3/cms/helpers/erb'

include Dkdeploy::Typo3::Cms::Helpers::Erb
include Dkdeploy::Helpers::Common
include Dkdeploy::Typo3::DSL

namespace :typo3 do
  namespace :cms do
    desc 'Clear typo3temp directory'
    task :clear_typo3temp do
      on release_roles :app do
        info I18n.t('tasks.clear_temp.clear', scope: :dkdeploy)
        execute :rm, '-rf', File.join(release_path, 'typo3temp', '*')
      end
    end

    desc 'Disable TYPO3 install tool'
    task :disable_install_tool do
      flag = File.join(current_path, 'typo3conf', 'ENABLE_INSTALL_TOOL')

      on release_roles :app do
        if test "[ -f #{flag} ]"
          info I18n.t('tasks.install_tool.disable', scope: :dkdeploy)
          execute :rm, flag
        end
      end
    end

    desc 'Enable TYPO3 install tool'
    task :enable_install_tool do
      on release_roles :app do
        info I18n.t('tasks.install_tool.enable', scope: :dkdeploy)
        execute :mkdir, '-p', File.join(current_path, 'typo3conf')
        execute :touch, File.join(current_path, 'typo3conf', 'ENABLE_INSTALL_TOOL')
      end
    end

    desc 'Create TYPO3 database config file'
    task :create_db_credentials do
      on release_roles(:app), in: :sequence do |server|
        db_settings = read_db_settings_for_context(self)
        if db_settings.nil?
          # No database settings found. Set database settings for current host
          invoke_for_server server, 'db:upload_settings'
          db_settings = read_db_settings_for_context(self)
        end

        config_file_content = <<-CONFIG_FILE_CONTENT
  <?php
  $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default'] = [
    'charset' => '#{db_settings.fetch('charset')}',
    'dbname' => '#{db_settings.fetch('name')}',
    'driver' => 'mysqli',
    'host' => '#{db_settings.fetch('host')}',
    'password' => '#{db_settings.fetch('password')}',
    'port' => #{db_settings.fetch('port')},
    'user' => '#{db_settings.fetch('username')}',
     // Use init commands from previous configuration files like LocalConfiguration.php
     'initCommands' => $GLOBALS['TYPO3_CONF_VARS']['DB']['Connections']['Default']['initCommands'] ?? ''
  ];
  CONFIG_FILE_CONTENT

        upload! StringIO.new(config_file_content), File.join(shared_path, 'config', "db_settings.#{fetch(:stage)}.php")
      end
    end

    desc 'Download extension to local workspace'
    task :fetch_extension, :extension do |_, args|
      extension = ask_variable(args, :extension, 'tasks.fetch_extension.extension_name')
      FileUtils.mkdir_p File.join('temp', 'extensions')
      FileUtils.remove_dir File.join('temp', 'extensions', extension), true
      source = File.join(current_path, 'typo3conf', 'ext', extension)
      target = File.join('temp', 'extensions')

      on primary(:backend) do
        if test "[ -d #{File.join(current_path, 'typo3conf', 'ext', extension)} ]"
          # download to temp
          info I18n.t('tasks.fetch_extension.download', extension: extension, scope: :dkdeploy)
          download! source, target, via: :scp, recursive: true
        else
          error I18n.t('tasks.fetch_extension.extension_not_found', extension: extension, scope: :dkdeploy)
          exit 1
        end
      end

      run_locally do
        # rsync to htdocs/typo3temp/ext
        info I18n.t('tasks.fetch_extension.rsync', extension: extension, scope: :dkdeploy)
        rsync_excludes = []
        rsync_exclude_directories = %w[.git/ .svn/]
        rsync_exclude_directories.each do |exclude|
          rsync_excludes << '--exclude=' + exclude
        end
        execute :rsync, '-vrS', '--force', '-C', '--delete', rsync_excludes, File.join('temp', 'extensions', extension, '/'), File.join('htdocs', 'typo3conf', 'ext', extension, '/')
      end
    end

    desc 'Output a generated encryption key'
    task :generate_encryption_key do
      puts SecureRandom.hex(48)
    end

    desc 'Create encryption key file on server'
    task :create_encryption_key_file, :encryption_key do |_, args|
      encryption_key_file_path = File.join(shared_path, 'config')
      encryption_key_file = File.join(encryption_key_file_path, 'encryption_key.php')
      encryption_key = ask_variable(args, :encryption_key, 'tasks.encryption_key.enter_key') { |question| question.echo = '*' }
      encryption_key.strip!

      if encryption_key.empty? || encryption_key.length < 8
        abort I18n.t('tasks.encryption_key.validation_error', scope: :dkdeploy)
      end

      encryption_key_file_content = "<?php $GLOBALS['TYPO3_CONF_VARS']['SYS']['encryptionKey'] = '#{encryption_key}';"

      on release_roles :app do ||
        execute :mkdir, '-p', encryption_key_file_path
        upload! StringIO.new(encryption_key_file_content), encryption_key_file
      end
    end

    desc 'Create install tool password file on server'
    task :create_install_tool_password_file, :password do |_, args|
      install_tool_file_path = File.join(shared_path, 'config')
      install_tool_file = File.join(install_tool_file_path, 'install_tool_password.php')
      password = ask_variable(args, :password, 'tasks.install_tool_password.enter_password') { |question| question.echo = '*' }
      password.strip!

      if password.empty?
        abort I18n.t('tasks.install_tool_password.validation_error', scope: :dkdeploy)
      end

      password = Phpass.new.hash password
      password_file_content = "<?php $GLOBALS['TYPO3_CONF_VARS']['BE']['installToolPassword'] = '#{password}';"

      on release_roles :app do ||
        execute :mkdir, '-p', install_tool_file_path
        upload! StringIO.new(password_file_content), install_tool_file
      end
    end

    desc 'Add TYPO3 admin backend user'
    task :add_admin_user, :typo3_username, :typo3_password do |_, args|
      remote_db_file_path = File.join(shared_path, 'config')
      remote_db_file = File.join(remote_db_file_path, "be-admin-user-#{fetch(:stage)}.sql")
      typo3_username = ask_variable(args, :typo3_username, 'tasks.db.username')
      typo3_password = ask_variable(args, :typo3_password, 'tasks.db.password') { |question| question.echo = '*' }
      now = Time.now.to_i

      sql_string = "INSERT INTO be_users (username, password, admin, tstamp, crdate)
                      VALUES ('#{typo3_username}', MD5('#{typo3_password}'), 1, #{now}, #{now});"

      on primary :backend do
        begin
          db_settings = read_db_settings_for_context(self)
          execute :mkdir, '-p', remote_db_file_path
          execute :rm, '-rf', remote_db_file

          upload! StringIO.new(sql_string), remote_db_file
          execute :mysql,
                  "--default-character-set=#{db_settings.fetch('charset')}",
                  '-u', db_settings.fetch('username'),
                  '-p',
                  '-h', db_settings.fetch('host'), '-P', db_settings.fetch('port'), db_settings.fetch('name'),
                  '-e', "'source #{remote_db_file}'",
                  interaction_handler: Dkdeploy::InteractionHandler::Password.new(db_settings.fetch('password'))
        ensure
          execute :rm, '-rf', remote_db_file
        end
      end
    end

    desc 'Create configured directories for TYPO3 extensions'
    task :fix_folder_structure do
      typo3_console 'install:fixfolderstructure'
    end

    desc 'Clear TYPO3 caches'
    task :clear_cache do |task|
      typo3_console 'cache:flush', true
      task.reenable
    end

    desc 'update_tables'
    task :update_database do
      again = nil
      capture_typo3_console_in_loop 10, 'database:updateschema', 'safe,*.prefix'.shellescape, '--verbose' do |output,_,context|
        context.info output
        again = !output.include?('No schema updates were performed for update types')
      end

      if again # if again ist true we ran loop 10 times and need to issue a warning
        run_locally do
          warn I18n.t('tasks.typo3.cms.update_database.still_updates_available', scope: :dkdeploy)
        end
      end
    end

    # Deactivate Task. Wait for https://github.com/TYPO3-Console/typo3_console/pull/288
    # desc 'add_static_db_content'
    # task :add_static_db_content do
    #   typo3_console 'database:importstaticdata'
    # end

    desc 'Update translations for core and extensions (l10n)'
    task :update_translations, :typo3_languages_to_translate do |_, args|
      typo3_languages_to_translate = ask_variable(args, :typo3_languages_to_translate, 'questions.typo3_languages_to_translate')
      typo3_cli 'lang:language:update', typo3_languages_to_translate
    end

    desc 'Remove not needed extensions'
    task :remove_extensions do
      installed_extensions = (capture_typo3_console_in_loop 1, 'extension:list', '--active', '--raw').split("\n")

      run_locally do
        info installed_extensions.inspect
        if installed_extensions.empty?
          raise I18n.t('tasks.typo3.cms.v6.remove_extensions.no_extension_found', scope: :dkdeploy)
        end
      end

      on roles :app do
        # Get extensions from typo3conf/ext directory
        remote_list = capture(:ls, '-x', File.join(current_path, 'typo3conf', 'ext')).split

        extensions_to_remove = (remote_list - installed_extensions)
        unless extensions_to_remove.empty?
          info I18n.t('tasks.typo3.cms.v6.remove_extensions.info', scope: :dkdeploy, removed_extensions: extensions_to_remove.join(', '))
          extensions_to_remove.each do |extension|
            execute :rm, '-rf', "#{release_path}/typo3conf/ext/#{extension}"
          end
        end
      end
    end

    desc 'Generate AdditionalConfiguration.php.erb for your project'
    task :generate_additional_configuration_template, :additional_configuration_template do |_, args|
      configuration_template = ask_variable(args, :additional_configuration_template, 'questions.additional_configuration_template')
      run_locally do
        if test("[ -f #{configuration_template} ]")
          info I18n.t('tasks.typo3.cms.v6.generate_additional_configuration_template.info', scope: :dkdeploy, local_configuration_template: configuration_template)
          exit 0
        else
          execute :mkdir, '-p', File.dirname(configuration_template)
          File.write configuration_template, File.read(default_template_file)
        end
      end
    end

    desc 'Sets up the TYPO3 6+ specific configuration for each stage'
    task :setup_additional_configuration, :additional_configuration_template do |_, args|
      configuration_template = ask_variable(args, :additional_configuration_template, 'questions.additional_configuration_template')
      remote_configuration_file = File.join(release_path, 'typo3conf', 'AdditionalConfiguration.php')
      unless File.exist?(configuration_template)
        run_locally do
          raise I18n.t('tasks.typo3.cms.v6.setup_additional_configuration.upload_info', configuration_template: configuration_template, scope: :dkdeploy)
        end
      end

      on roles :app do |server|
        # Variable "server" need for the template rendering. "server.fetch(:additional_configuration_file)"
        merged_template = ERB.new File.read(configuration_template), nil, '>'
        upload! StringIO.new(merged_template.result(binding)), remote_configuration_file, scp: true
        info I18n.t('tasks.typo3.cms.v6.setup_additional_configuration.upload_info', scope: :dkdeploy, remote_configuration_file: remote_configuration_file)
      end
    end
  end
end
