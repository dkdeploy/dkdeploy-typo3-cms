Feature: Test tasks for namespace 'typo3:cms'

	Background:
		Given a test app with the default configuration
		And the remote server is cleared
		And I run `cap dev deploy`

	Scenario: Generate custom ERB Template with custom name
		Given I successfully run `cap dev typo3:cms:generate_additional_configuration_template['vendor/customer_specific_config.php.erb']`
		Then a file named "vendor/customer_specific_config.php.erb" should exist

	Scenario: Use custom ERB Template to generate "AdditionalConfiguration.php" file
		Given a file named "vendor/customer_specific_config.php.erb" with:
		"""
<?php
<% if File.exist?(File.join('htdocs', 'typo3conf', 'AdditionalConfiguration.php')) %>
<%= sanitize_php File.read(File.join('htdocs', 'typo3conf', 'AdditionalConfiguration.php')) %>
<% end %>
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
		"""
		When I successfully run `cap dev typo3:cms:setup_additional_configuration['vendor/customer_specific_config.php.erb']`
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
putenv('TYPO3_DISABLE_CORE_UPDATER=1');
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
		"""


	Scenario: Setup no stage specific configuration
		Given a file named "htdocs/typo3conf/AdditionalConfiguration.php" with:
		"""
		<?php
		// I am the default AdditionalConfiguration.php.
		?>
		"""
		When I successfully run `cap dev typo3:cms:setup_additional_configuration --trace`
		Then a remote file named "current_path/typo3conf/AdditionalConfiguration.php" should exist
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
// Content of default configuration file
// I am the default AdditionalConfiguration.php.

// Include section
		"""

	Scenario: Setup stage specific configuration
		Given a file named "htdocs/typo3conf/AdditionalConfiguration.php" with:
		"""
		<?php
		// I am the default AdditionalConfiguration.php and I shall be merged!
		?>
		"""
		And a file named "config/typo3/AdditionalConfiguration.dev.php" with:
		"""

		<?php
		// I am AdditionalConfiguration.dev.php. I hope to survive this merge.
		// Here are some additional settings
		?>
		"""
		When I successfully run `cap dev typo3:cms:setup_additional_configuration`
		Then a remote file named "current_path/typo3conf/AdditionalConfiguration.php" should exist
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
// Content of default configuration file
// I am the default AdditionalConfiguration.php and I shall be merged!

// Content of stage configuration file
// I am AdditionalConfiguration.dev.php. I hope to survive this merge.
// Here are some additional settings

// Include section
		"""

	Scenario: Extend file "AdditionalConfiguration" with content from extra configuration files
		Given a file named "config/typo3/ExtraConfiguration.php" with:
		"""
<?php
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
		"""
		And I extend the development capistrano configuration variable additional_configuration_files with value ['config/typo3/ExtraConfiguration.php']
		When I successfully run `cap dev typo3:cms:setup_additional_configuration`
		Then a remote file named "current_path/typo3conf/AdditionalConfiguration.php" should exist
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
// Content of default configuration file
putenv('TYPO3_DISABLE_CORE_UPDATER=1');

// Content of additional configuration file "ExtraConfiguration.php"
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;

// Include section
		"""

	Scenario: Extend file "AdditionalConfiguration" with content from extra ruby template configuration files
		Given a file named "config/typo3/ExtraConfiguration.php.erb" with:
		"""
<?php
$extraConfiguration = '<%= server %>';
		"""
		And I extend the development capistrano configuration variable additional_configuration_files with value ['config/typo3/ExtraConfiguration.php.erb']
		When I successfully run `cap dev typo3:cms:setup_additional_configuration`
		Then a remote file named "current_path/typo3conf/AdditionalConfiguration.php" should exist
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
// Content of default configuration file
putenv('TYPO3_DISABLE_CORE_UPDATER=1');

// Content of additional configuration file "ExtraConfiguration.php.erb"
$extraConfiguration = 'dkdeploy-typo3-cms.dev';

// Include section
		"""

	Scenario: Extend file "AdditionalConfiguration" with content from server configuration files
		Given a file named "config/typo3/ServerConfiguration.php" with:
		"""
<?php
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;
		"""
		And I extend the development capistrano configuration from the fixture file additional_configuration_for_server.rb
		When I successfully run `cap dev typo3:cms:setup_additional_configuration`
		Then a remote file named "current_path/typo3conf/AdditionalConfiguration.php" should exist
		And the remote file "current_path/typo3conf/AdditionalConfiguration.php" should contain exactly:
		"""
<?php
// Content of default configuration file
putenv('TYPO3_DISABLE_CORE_UPDATER=1');

// Content of server "dkdeploy-typo3-cms.dev" configuration file "ServerConfiguration.php"
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = 1;

// Include section
		"""

	Scenario: Task "typo3:cms:remove_extensions" does not remove extension directory
		Given a successfully deployed TYPO3 application
		When I successfully run `cap dev typo3:cms:remove_extensions`
		Then a remote directory named "current_path/typo3conf/ext/realurl" should exist

	Scenario: Task "typo3:cms:remove_extensions" does remove extension directory
		Given a successfully deployed TYPO3 application
		And a remote directory named "current_path/typo3conf/ext/test_extension"
		When I successfully run `cap dev typo3:cms:remove_extensions`
		Then a remote directory named "current_path/typo3conf/ext/test_extension" should not exist

	Scenario: Task "typo3:cms:create_extension_folders" create needed directories
		Given a successfully deployed TYPO3 application
		And a remote directory named "current_path/uploads/tx_realurl" should not exist
		When I successfully run `cap dev typo3:cms:fix_folder_structure`
		Then a remote directory named "current_path/uploads/tx_realurl" should exist
