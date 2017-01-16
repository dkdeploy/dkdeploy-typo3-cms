Feature: Test tasks for namespace 'typo3:cms'

	Background:
		Given a test app with the default configuration
		And the remote server is cleared

	Scenario: Toggle TYPO3 Install Tool
		When I successfully run `cap dev typo3:cms:enable_install_tool`
		Then a remote file named "current_path/typo3conf/ENABLE_INSTALL_TOOL" should exist
		When I successfully run `cap dev typo3:cms:disable_install_tool`
		Then a remote file named "current_path/typo3conf/ENABLE_INSTALL_TOOL" should not exist

	Scenario: Clear typo3temp
		Given a remote empty file named "release_path/typo3temp/testdirectory/file.png"
		When I successfully run `cap dev typo3:cms:clear_typo3temp`
		Then a remote directory named "current_path/typo3temp/testdirectory" should not exist
		And a remote file named "current_path/typo3temp/testdirectory/file.png" should not exist

	Scenario: Fetch extension if it exists
		And the project is deployed
		Given a remote empty file named "current_path/typo3conf/ext/demo/extension.php"
		And a remote directory named "current_path/typo3conf/ext/demo/.git/gitRemote"
		And a remote directory named "current_path/typo3conf/ext/demo/.svn/svnRemote"
		And an empty file named "htdocs/typo3conf/ext/demo/toBeDeleted.php"
		And an empty file named "htdocs/typo3conf/ext/demo/.git/gitOriginal"
		And an empty file named "htdocs/typo3conf/ext/demo/.svn/svnOriginal"
		When I run `cap dev typo3:cms:fetch_extension` interactively
		And I type "demo"
		And I close the stdin stream
		Then the exit status should be 0
		When I wait 5 seconds to let the filesystem write the changes to disk
		Then a file named "htdocs/typo3conf/ext/demo/extension.php" should exist
		And a file named "htdocs/typo3conf/ext/demo/toBeDeleted.php" should not exist
		And a file named "htdocs/typo3conf/ext/demo/.git/gitOriginal" should exist
		And a file named "htdocs/typo3conf/ext/demo/.git/gitRemote" should not exist
		And a file named "htdocs/typo3conf/ext/demo/.svn/svnOriginal" should exist
		And a file named "htdocs/typo3conf/ext/demo/.svn/svnRemote" should not exist

	Scenario: Fetch extension if it does not exist
		Given a remote empty file named "current_path/typo3conf/ext/demo/extension.php"
		Then a remote file named "current_path/typo3conf/ext/demo/extension.php" should exist
		When I run `cap dev typo3:cms:fetch_extension` interactively
		And I type "cowabonga"
		And I close the stdin stream
		Then the output should contain "Extension 'cowabonga' not found!"

	Scenario: Check creation of TYPO3 database config file
		Given I want to use the database `dkdeploy_typo3_cms`
		When I successfully run `cap dev "db:upload_settings[127.0.0.1,3306,dkdeploy,root,ilikerandompasswords,utf8]"`
		When I successfully run `cap dev typo3:cms:create_db_credentials`
		Then a remote file named "shared_path/config/db_settings.dev.php" should exist

	Scenario: Check creation of TYPO3 database config file even if remote database config does not exist
		Given I want to use the database `dkdeploy_typo3_cms`
		Then a remote file named "shared_path/config/db_settings.dev.php" should not exist
		When I run `cap dev typo3:cms:create_db_credentials` interactively
		And I type "127.0.0.1"
		And I type "3306"
		And I type "dkdeploy_typo3_cms"
		And I type "root"
		And I type "ilikerandompasswords"
		And I type "utf8"
		And I close the stdin stream
		Then the exit status should be 0
		Then a remote file named "shared_path/config/db_settings.dev.php" should exist

	Scenario: Check generation of encryption key
		When I successfully run `cap dev typo3:cms:generate_encryption_key`
		Then the output should match /[0-9a-fA-F]{80}/

	Scenario: Check creation of encryption key file on server
		When I successfully run `cap dev "typo3:cms:create_encryption_key_file[my-encryption-key]"`
		Then the remote file "shared_path/config/encryption_key.php" should contain exactly:
		"""
		<?php $GLOBALS['TYPO3_CONF_VARS']['SYS']['encryptionKey'] = 'my-encryption-key';
		"""

	Scenario: Check creation of TYPO3 Install Tool password
		When I successfully run `cap dev "typo3:cms:create_install_tool_password_file[super-secret-password]"`
		Then a remote file named "shared_path/config/install_tool_password.php" should exist

	Scenario: Check adding a TYPO3 admin user
		Given I want to use the database `dkdeploy_typo3_cms`
		Given the TYPO3 table be_users exists
		When I run `cap dev typo3:cms:create_db_credentials` interactively
		And I type "127.0.0.1"
		And I type "3306"
		And I type "dkdeploy_typo3_cms"
		And I type "root"
		And I type "ilikerandompasswords"
		And I type "utf8"
		And I close the stdin stream
		Then the exit status should be 0
		When I run `cap dev typo3:cms:add_admin_user` interactively
		And I type "admin"
		And I type "secret-password"
		And I close the stdin stream
		And I wait 10 second to let the database commit the transaction
		Then the database should have a value `admin` in table `be_users` for column `username`
		Then the database should have a value `2304d4770a72d09106045fea654c4188` in table `be_users` for column `password`
