name 'dkdeploy-typo3-cms'
maintainer 'dkd Internet Service GmbH'
license 'MIT'
description 'Project cookbook'
version '1.0'

depends 'mysql', '~> 6.1'
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 5.1'
depends 'apache2', '~> 3.2'
depends 'php', '~> 1.9'
depends 'apt', '~> 3.0' # version 2.9 is causing dependency issues
