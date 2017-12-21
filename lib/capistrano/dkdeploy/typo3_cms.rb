require 'capistrano/dkdeploy/php'

include Capistrano::DSL

# Load dkdeploy tasks
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/typo3.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/typoscript.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/cache.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/cli.rake', __FILE__)
load File.expand_path('../../../dkdeploy/typo3/cms/tasks/caretaker_key_management.rake', __FILE__)

namespace :load do
  task :defaults do
    set :asset_folders, %w[fileadmin uploads]
    set :asset_default_content, fetch(:asset_folders)
    set :typoscript_userts_file, 'UserTS.txt'
    set :typoscript_pagets_file, 'PageTS.txt'
    set :typoscript_config_file, 'config.txt'
    set :create_new_caretaker_keys, 'false'
    set :caretaker_public_key_path, -> { File.join(shared_path, 'config', 'pubkey.pem') }
    set :caretaker_private_key_path, -> { File.join(shared_path, 'config', 'privkey.pem') }
    set :create_caretaker_instance_keys_template, -> { File.join(__dir__, '..', '..', '..', 'vendor', 'create_caretaker_instance_keys.php.erb') }
    set :create_caretaker_instance_keys_path, -> { File.join(shared_path, 'config', 'create_caretaker_instance_keys.php') }
    set :caretaker_instance_keys_path, -> { File.join(shared_path, 'config', 'caretaker_instance_keys.php') }

    set :typo3_environment_cli, {
      TERM: 'screen-256color'
    }

    set :additional_ignore_tables, fetch(:additional_ignore_tables, []) + %w[
      be_sessions
      be_users
      cache_md5params
      cache_treelist
      cf_cache_hash
      cf_cache_hash_tags
      cf_cache_imagesizes
      cf_cache_imagesizes_tags
      cf_cache_news_category
      cf_cache_news_category_tags
      cf_cache_pages
      cf_cache_pages_tags
      cf_cache_pagesection
      cf_cache_rootline
      cf_cache_rootline_tags
      cf_extbase_datamapfactory_datamap
      cf_extbase_datamapfactory_datamap_tags
      cf_extbase_object
      cf_extbase_object_tags
      cf_extbase_reflection
      cf_extbase_reflection_tags
      cf_news
      cf_news_tags
      cf_themes_cache
      cf_themes_cache_tags
      cf_workspaces_cache
      cf_workspaces_cache_tags
      fe_session_data
      fe_sessions
      fe_users
      sys_be_shortcuts
      sys_domain
      sys_file_processedfile
      sys_history
      sys_lockedrecords
      sys_log
      tx_dkdstandard_migration_versions
      tx_impexp_presets
      tx_realurl_chashcache
      tx_realurl_pathcache
      tx_realurl_pathdata
      tx_realurl_uniqalias_cache_map
      tx_realurl_urldata
      tx_realurl_urldecodecache
      tx_realurl_urlencodecache
      tx_rsaauth_keys
      tx_solr_cache
      tx_solr_cache_tags
      tx_solr_indexqueue_indexing_property
      tx_solr_indexqueue_item
      tx_solr_last_searches
      tx_solr_statistics
    ]

    # Path to typo3_console. Relative path to typo3_console script
    set :path_to_typo3_console, File.join('bin', 'typo3cms')
    set :path_to_typo3_cli, File.join('bin', 'typo3')

    set :additional_configuration_template, File.join(__dir__, '..', '..', '..', 'vendor', 'AdditionalConfiguration.php.erb')
    set :additional_configuration_files, []

    add_rollback_task('typo3:cms:cache:clear_file_cache')
  end
end
