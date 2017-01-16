Feature: Test tasks for namespace 'typo3:cms'

	Background:
		Given a test app with the default configuration
		And the remote server is cleared
		And I want to use the database `dkdeploy_typo3_cms`
		And a successfully deployed TYPO3 application

	Scenario: Rename not needed table to "zzz_deleted_"
		Given the database table `no_needed_table` exists
		When I successfully run `cap dev typo3:cms:update_database`
		Then the database should not have a table `no_needed_table`
		Then the database should have a table `zzz_deleted_no_needed_table`

	Scenario: Create needed table if needed
		Given drop the database table `tx_realurl_urldata`
		When I successfully run `cap dev typo3:cms:update_database`
		Then the database should have a table `tx_realurl_urldata`

	Scenario: Do not delete needed tables
		Given the database table `tx_realurl_urldata` exists
		When I successfully run `cap dev typo3:cms:update_database`
		Then the database should not have a table `zzz_deleted_tx_realurl_urldata`
