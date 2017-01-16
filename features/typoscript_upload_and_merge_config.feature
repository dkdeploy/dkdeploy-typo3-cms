Feature: Test tasks for namespace 'typo3:cms:typoscript'

	Background:
		Given a test app with the default configuration
		And the remote server is cleared

	Scenario: Merging remote config files
		Given a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages/config.dev.txt" with:
			"""
			content
			"""
		And a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages/config.dev.txt" with:
			"""
			different content
			"""
		When I run `cap dev typo3:cms:typoscript:merge_configs` interactively
		And I type "typo3conf/ext/dkdeploy/res/demo1/typoscript/constants typo3conf/ext/dkdeploy/res/demo2/typoscript/constants"
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages/config.dev.txt" should contain exactly:
			"""
			content
			"""
		Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages/config.dev.txt" should contain exactly:
			"""
			different content
			"""

	Scenario: Uploading config files if file does not exist
		When I run `cap dev typo3:cms:typoscript:upload_configs` interactively
		And I type "nonexisting_file"
		And I close the stdin stream
		Then the exit status should be 0
		Then the output should contain "Skipping htdocs/nonexisting_file"

	Scenario: Uploading config files if everything works smoothly for one config file
		Given an empty file named "htdocs/demo1/config.txt"
		When I run `cap dev typo3:cms:typoscript:upload_configs` interactively
		And I type "demo1"
		And I close the stdin stream
		Then the exit status should be 0
		Then a remote file named "current_path/demo1/config.txt" should exist

	Scenario: Uploading config files if everything works smoothly for several config files
		Given a file named "htdocs/demo1/config.txt" with:
			"""
			first content
			"""
		Given a file named "htdocs/demo2/config.txt" with:
			"""
			second content
			"""
		Given a file named "htdocs/demo3/config.txt" with:
			"""
			third content
			"""
		When I run `cap dev typo3:cms:typoscript:upload_configs` interactively
		And I type "demo1 demo2 demo3"
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/demo1/config.txt" should contain exactly:
			"""
			first content
			"""
		Then the remote file "current_path/demo2/config.txt" should contain exactly:
			"""
			second content
			"""
		Then the remote file "current_path/demo3/config.txt" should contain exactly:
			"""
			third content
			"""

	Scenario: Uploading all config files from base path if everything works smoothly for several config files
		Given a file named "htdocs/demo1/config.txt" with:
			"""
			first content
			"""
		Given a file named "htdocs/demo2/config.txt" with:
			"""
			second content
			"""
		Given a file named "htdocs/demo3/config.txt" with:
			"""
			third content
			"""
		When I run `cap dev typo3:cms:typoscript:upload_config_from_base_path` interactively
		And I type "."
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/demo1/config.txt" should contain exactly:
			"""
			first content
			"""
		Then the remote file "current_path/demo2/config.txt" should contain exactly:
			"""
			second content
			"""
		Then the remote file "current_path/demo3/config.txt" should contain exactly:
			"""
			third content
			"""

	Scenario: Merging all remote config files in a given base path
		Given a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages/config.dev.txt" with:
			"""
			content
			"""
		And a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages/config.dev.txt" with:
			"""
			different content
			"""
		When I run `cap dev typo3:cms:typoscript:merge_config_in_base_path` interactively
		And I type "typo3conf/ext/dkdeploy"
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/config.txt" should contain exactly:
			"""
			content
			"""
		Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/config.txt" should contain exactly:
			"""
			different content
			"""
