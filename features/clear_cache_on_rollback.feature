Feature: Clearing file cache when deployment fails
  Background:
    Given a test app with the default configuration
    And the remote server is cleared
    And I run `cap dev deploy`


  Scenario: When deployment fails after symlinking the new release
    Given a remote directory named "current_path/typo3temp/Cache"
    And a remote file named "current_path/typo3temp/Cache/test_cache_file" with:
    """
    cached content
    """
    And I provoke an exception for testing purposes after symlinking the new release
    When I run `cap dev deploy`
    And the exit status should not be 0
    And a remote file named "current_path/typo3temp/Cache/test_cache_file" should not exist
