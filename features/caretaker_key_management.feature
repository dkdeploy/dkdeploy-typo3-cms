Feature: Test tasks in namespace 'caretaker'

  Background:
    Given a test app with the default configuration
    And the remote server is cleared

  Scenario: Testing creation of keys
    When I successfully run `cap dev caretaker:create_keys`
    Then a remote file named "shared_path/config/privkey.pem" should exist
    And a remote file named "shared_path/config/pubkey.pem" should exist
    And a remote file named "caretaker_instance_keys.php" should not exist

  Scenario: Testing forceful creation of keys
    When I successfully run `cap dev "caretaker:create_keys[yes]"`
    Then a remote file named "shared_path/config/privkey.pem" should exist
    And a remote file named "shared_path/config/pubkey.pem" should exist
    And a remote file named "caretaker_instance_keys.php" should not exist

  Scenario: Testing display of keys
    Given I successfully run `cap dev "caretaker:create_keys"`
    When I successfully run `cap dev "caretaker:show_public_key"`
    And the output should contain "Output file /var/www/dkdeploy/shared/config/pubkey.pem (dkdeploy-typo3-cms.dev):"
    Then the output should match:
    """
    -----BEGIN PUBLIC KEY-----
    .*
    -----END PUBLIC KEY-----
    """
    And the output should contain:
    """
    One line public key (dkdeploy-typo3-cms.dev):
    """
    And the output should match:
    """
    -----BEGIN PUBLIC KEY-----.*-----END PUBLIC KEY-----
    """