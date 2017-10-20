unless Vagrant.has_plugin?('vagrant-berkshelf')
  puts "Please install vagrant plugin vagrant-berkshelfs first\n"
  puts " vagrant plugin install vagrant-berkshelf\n\n"
  puts "Exit vagrant\n\n"
  abort
end

Vagrant.require_version '~> 2.0.0'
chef_version = '12.9.41'

Vagrant.configure(2) do |config|
  domain = 'dkdeploy-typo3-cms.dev'
  ip_address = '192.168.156.183'

  config.vm.box = 'ubuntu/xenial64'
  config.vm.box_check_update = false
  config.berkshelf.enabled = true

  config.vm.define 'dkdeploy-typo3-cms', primary: true do |master_config|
    master_config.vm.network 'private_network', ip: ip_address

    # Chef settings
    master_config.vm.provision :chef_solo do |chef|
      chef.version = chef_version
      chef.install = true
      chef.channel = 'stable'
      chef.log_level = :info
      chef.add_recipe 'dkdeploy-typo3-cms'

      # Specify custom JSON attributes:
      chef.json = { apache: { mpm: 'prefork' } }
    end

    # Memory limit and name of VirtualBox
    master_config.vm.provider 'virtualbox' do |virtualbox|
      virtualbox.gui = ENV['ENABLE_GUI_MODE'] && ENV['ENABLE_GUI_MODE'] =~ /^(true|yes|y|1)$/i
      virtualbox.customize [
        'modifyvm', :id,
        '--natdnsproxy1', 'off',
        '--natdnshostresolver1', 'on',
        '--memory', '1024',
        '--name', 'dkdeploy-typo3-cms'
      ]
    end
  end

  if Vagrant.has_plugin?('landrush')
    config.landrush.enabled = true
    config.landrush.guest_redirect_dns = false
    config.landrush.tld = 'dev'
    config.landrush.host domain, ip_address
  else
    config.vm.post_up_message = "Either install Vagrant plugin 'landrush' or add this entry to your host file: #{ip_address} #{domain}"
  end
end
