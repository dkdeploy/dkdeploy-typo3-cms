set :deploy_to, '/var/www/dkdeploy'
server 'dkdeploy-typo3-cms.dev', roles: %w[web app backend], primary: true

# no ssh compression on the dev stage
set :ssh_options, {
  compression: 'none'
}

ssh_key_files = Dir.glob(File.join(Dir.getwd, '..', '..', '.vagrant', 'machines', '**', 'virtualbox', 'private_key'))
unless ssh_key_files.empty?
  # Define generated ssh key files
  set :ssh_options, fetch(:ssh_options).merge(
    {
      user: 'ubuntu',
      keys: ssh_key_files
    }
  )
end

set :typoscript_userts_file, 'UserTS.txt'
set :typoscript_pagets_file, 'PageTS.txt'
set :typoscript_config_file, 'config.txt'

set :copy_source, 'htdocs'
set :copy_exclude, %w[
  Gemfile*
  .hidden
  **/.hidden
]

# custom file access properties
set :custom_file_access, {
  app: {
    catalog: {
      owner: 'test-user',
      group: 'test-group',
      mode: 'a+rwx,o-wx',
      recursive: true
    }
  }
}
