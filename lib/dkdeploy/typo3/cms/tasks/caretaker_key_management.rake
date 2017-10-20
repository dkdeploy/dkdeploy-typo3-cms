require 'erb'
require 'capistrano/i18n'
require 'dkdeploy/typo3/cms/i18n'
require 'dkdeploy/typo3/cms/helpers/cli'

include Dkdeploy::Typo3::Cms::Helpers::Cli

namespace :caretaker do
  desc 'Create - if necessary or configured - and configure TYPO3 Caretaker SSL keys'
  task :create_keys, :create_new_caretaker_keys do |_, args|
    create_new_keys = ask_variable(args, :create_new_caretaker_keys, 'questions.create_new_keys') == 'yes'

    on roles :app do |server|
      key_is_missing = !test("[ -f #{fetch(:caretaker_private_key_path)} ]")

      if create_new_keys || key_is_missing
        begin
          execute :mkdir, '-p', File.join(shared_path, 'config')
          execute :openssl, 'genrsa', '-out', fetch(:caretaker_private_key_path), '2048', '2>/dev/null'
          execute :openssl, 'rsa', '-in', fetch(:caretaker_private_key_path), '-pubout', '-out', fetch(:caretaker_public_key_path), '2>&1'
        rescue SSHKit::Command::Failed
          error I18n.t('tasks.caretaker.errors.creating_keys_failed', host: server.hostname, scope: :dkdeploy)
          execute :rm, '-f', fetch(:caretaker_private_key_path)
          execute :rm, '-f', fetch(:caretaker_public_key_path)
          exit 1
        end
      end

      begin
        create_caretaker_instance_keys_template = ERB.new(File.read(fetch(:create_caretaker_instance_keys_template)), nil, '>')
        create_caretaker_instance_keys_content = create_caretaker_instance_keys_template.result(binding)
        upload! StringIO.new(create_caretaker_instance_keys_content), fetch(:create_caretaker_instance_keys_path), scp: true
        execute :php, '-f', fetch(:create_caretaker_instance_keys_path)
        execute :rm, '-f', fetch(:create_caretaker_instance_keys_path)
      rescue SSHKit::Command::Failed
        error I18n.t('tasks.caretaker.errors.configuring_keys_failed', host: server.hostname, scope: :dkdeploy)
        execute :rm, '-r', fetch(:create_caretaker_instance_keys_path)
        execute :rm, '-r', fetch(:caretaker_instance_keys_path)
        exit 1
      end
    end
  end

  desc 'Display Caretaker SSL public key'
  task :show_public_key do
    on roles :app do |server|
      if test("[ -f #{fetch(:caretaker_public_key_path)} ]")
        public_key = capture :cat, fetch(:caretaker_public_key_path)
      else
        error I18n.t('tasks.caretaker.errors.public_key_not_found', public_key_path: fetch(:caretaker_public_key_path), host: server.hostname, scope: :dkdeploy)
        exit 1
      end

      info I18n.t('tasks.caretaker.info.output_file', output_file: fetch(:caretaker_public_key_path), host: server.hostname, scope: :dkdeploy)
      info public_key
      info I18n.t('tasks.caretaker.info.output_file_one_liner', output_file: fetch(:caretaker_public_key_path), host: server.hostname, scope: :dkdeploy)
      info public_key.gsub(/\n/m, '|')
    end
  end
end
