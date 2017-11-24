name 'dkdeploy-typo3-cms'
maintainer 'dkd Internet Service GmbH'
license 'MIT'
description 'Project cookbook'
version '1.0'

depends 'mysql', '~> 8.5.1'
depends 'mysql2_chef_gem', '~> 1.0'
depends 'database', '~> 5.1'
depends 'apache2', '~> 5.0.1'
depends 'php', '~> 4.5.0'
depends 'apt', '~> 3.0' # version 2.9 is causing dependency issues
