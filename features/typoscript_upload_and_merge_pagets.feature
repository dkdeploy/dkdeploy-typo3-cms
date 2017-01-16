Feature: Test tasks for namespace 'typo3:cms:typoscript'

	Background:
		Given a test app with the default configuration
		And the remote server is cleared

	Scenario: Merging remote PageTS files
		Given a remote directory named "current_path/typo3conf/ext/dkdeploy_2/Configuration/TypoScript/TSConf/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy_2/Configuration/TypoScript/TSConf/Stages/PageTS.dev.txt" with:
      """
      content
      """
		And a remote directory named "current_path/typo3conf/ext/dkdeploy_3/Configuration/TypoScript/TSConf/Stages"
		And a remote file named "current_path/typo3conf/ext/dkdeploy_3/Configuration/TypoScript/TSConf/Stages/PageTS.dev.txt" with:
		  """
		  different content
		  """
		When I run `cap dev typo3:cms:typoscript:merge_pagets` interactively
		And I type "typo3conf/ext/dkdeploy_2/Configuration/TypoScript/TSConf typo3conf/ext/dkdeploy_3/Configuration/TypoScript/TSConf"
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/typo3conf/ext/dkdeploy_2/Configuration/TypoScript/TSConf/PageTS.txt" should contain exactly:
      """
      content
      """
		Then the remote file "current_path/typo3conf/ext/dkdeploy_3/Configuration/TypoScript/TSConf/PageTS.txt" should contain exactly:
      """
      different content
      """

	Scenario: Uploading PageTS files if file does not exist
		When I run `cap dev typo3:cms:typoscript:upload_pagets` interactively
		And I type "nonexisting_file"
		And I close the stdin stream
		Then the exit status should be 0
		Then the output should contain "Skipping htdocs/nonexisting_file"

	Scenario: Uploading PageTS files if everything works smoothly for one config file
		Given an empty file named "htdocs/demo1/PageTS.txt"
		When I run `cap dev typo3:cms:typoscript:upload_pagets` interactively
		And I type "demo1"
		And I close the stdin stream
		Then the exit status should be 0
		Then a remote file named "current_path/demo1/PageTS.txt" should exist

	Scenario: Uploading PageTS files if everything works smoothly for several PageTS files
		Given a file named "htdocs/demo1/PageTS.txt" with:
      """
      first content
      """
	  Given a file named "htdocs/demo2/PageTS.txt" with:
      """
      second content
      """
	  Given a file named "htdocs/demo3/PageTS.txt" with:
      """
      third content
      """
		When I run `cap dev typo3:cms:typoscript:upload_pagets` interactively
		And I type "demo1 demo2 demo3"
		And I close the stdin stream
		Then the exit status should be 0
		Then the remote file "current_path/demo1/PageTS.txt" should contain exactly:
			"""
			first content
			"""
		Then the remote file "current_path/demo2/PageTS.txt" should contain exactly:
			"""
			second content
			"""
		Then the remote file "current_path/demo3/PageTS.txt" should contain exactly:
			"""
			third content
			"""

  Scenario: Uploading all PageTS files from base path if everything works smoothly for several config files
    Given a file named "htdocs/demo1/PageTS.txt" with:
      """
      first content
      """
    Given a file named "htdocs/demo2/PageTS.txt" with:
      """
      second content
      """
    Given a file named "htdocs/demo3/PageTS.txt" with:
      """
      third content
      """
    When I run `cap dev typo3:cms:typoscript:upload_pagets_from_base_path` interactively
    And I type "."
    And I close the stdin stream
    Then the exit status should be 0
    Then the remote file "current_path/demo1/PageTS.txt" should contain exactly:
      """
      first content
      """
    Then the remote file "current_path/demo2/PageTS.txt" should contain exactly:
      """
      second content
      """
    Then the remote file "current_path/demo3/PageTS.txt" should contain exactly:
      """
      third content
      """

  Scenario: Merging all remote PageTS files in a given base path
    Given a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages"
    And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/Stages/PageTS.dev.txt" with:
      """
      content
      """
    And a remote directory named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages"
    And a remote file named "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/Stages/PageTS.dev.txt" with:
      """
      different content
      """
    When I run `cap dev typo3:cms:typoscript:merge_pagets_in_base_path` interactively
    And I type "typo3conf/ext/dkdeploy"
    And I close the stdin stream
    Then the exit status should be 0
    Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo1/typoscript/constants/PageTS.txt" should contain exactly:
      """
      content
      """
    Then the remote file "current_path/typo3conf/ext/dkdeploy/res/demo2/typoscript/constants/PageTS.txt" should contain exactly:
      """
      different content
      """
