require 'i18n'

en = {
  questions: {
    create_new_keys: "Please enter 'yes' to create new Caretaker keys (everything else will not touch existing keys)",
    additional_configuration_template: 'Please specify the location for the additional configuration file (e.g. vendor/AdditionalConfiguration.php.erb)',
    typo3_languages_to_translate: 'Please specify the languages you wish to translate',
    path: 'please specify the path'
  },
  dsl: {
    invoke_for_server: {
      set_filter: "Invoking task '%{task}' for server '%{host}'"
    }
  },
  tasks: {
    caretaker: {
      errors: {
        public_key_not_found: 'Public key at %{public_key_path} on %{host} not found!',
        creating_keys_failed: 'Could not create Caretaker SSL keys on %{host}!',
        configuring_keys_failed: 'Could not configure Caretaker SSL keys on %{host}!'
      },
      info: {
        output_file: 'Output file %{output_file} (%{host}):',
        output_file_one_liner: 'One line public key (%{host}):'
      }
    },
    cli: {
      show_loop_counter: 'Running cli task for the %{loop_counter}. time',
      maximum_calls_reached: 'Maximum number of cli calls reached!',
      block_yields_false: 'Breaking loop after %{loop_counter} run because block yields false'
    },
    db: {
      username: 'Please enter TYPO3 admin username',
      password: 'Please enter TYPO3 admin password'
    },
    fetch_extension: {
      extension_name: 'Please enter name of extension',
      extension_not_found: "Extension '%{extension}' not found!",
      download: 'Downloading %{extension}...',
      rsync: 'Rsyncing %{extension}...'
    },
    clear_temp: {
      clear: 'Clearing typo3temp directory...'
    },
    install_tool: {
      enable: 'Enabling install tool...',
      disable: 'Disabling install tool...'
    },
    fetch_localconf: {
      fetch: 'Fetching localconf...'
    },
    typoscript: {
      copy_source: 'Please enter a common prefix for all config paths:',
      config_paths: 'Please enter a space separated list of remote config paths:',
      pagets_paths: 'Please enter a space separated list of remote PageTS paths:',
      userts_paths: 'Please enter a space separated list of remote UserTS paths:',
      config_file: 'Please enter the name of the config file:',
      pagets_file: 'Please enter the name of the PageTS file:',
      userts_file: 'Please enter the name of the UserTS file:',
      typoscript_config_base_path: 'Please enter the base path of config files:',
      typoscript_pagets_base_path: 'Please enter the base path of PageTS files:',
      typoscript_userts_base_path: 'Please enter the base path of UserTS files:',
      skipping: 'Skipping %{file_or_directory} because it does not exist...',
      uploading: 'Uploading %{local_file} to %{remote_file}...',
      uploaded: 'Uploaded %{local_file} to %{remote_file}.',
      merged: 'Merged %{source_file} with %{target_file}.'
    },
    encryption_key: {
      enter_key: 'Enter an encryption key (should be at least 9 characters):',
      validation_error: 'Encryption key is empty or less than 9 characters.'
    },
    install_tool_password: {
      enter_password: 'Install tool password:',
      validation_error: 'Install tool password is empty.'
    },
    processed_file_checksums: {
      typo3_version: 'Running TYPO3 CMS Version %{typo3_version}',
      task_does_not_apply: 'This task does not apply!',
      nothing_to_do: 'No updates to perform. All processed files checksums have already been updated.',
      all_done: 'All processed file checksums updated!'
    },
    typo3: {
      cms: {
        v6: {
          generate_additional_configuration_template: {
            info: 'No need to generate template. There already is one in %{local_configuration_template}'
          },
          setup_additional_configuration: {
            no_template_found: 'Can not find "AdditionalConfiguration.php" template at "%{configuration_template}"',
            upload_info: 'Uploading merged AdditionalConfiguration to %{remote_configuration_file}',
            no_local_file_info: '%{local_configuration_template} does not exist. File upload cancelled.',
            file_not_found_and_ignored: 'Configuration file %{file} does not exist. File ignored.'
          },
          remove_extensions: {
            info: 'The following extensions were removed: %{removed_extensions}',
            no_extension_found: 'No installed extension found'
          }
        },
        update_database: {
          still_updates_available: 'Still database schema updates available. See log for details.'
        }
      }
    }
  }
}

I18n.backend.store_translations(:en, dkdeploy: en)

if I18n.respond_to?(:enforce_available_locales=)
  I18n.enforce_available_locales = true
end
