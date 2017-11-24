Feature: Test tasks for namespace 'typo3:cms:cli:run'

  Background:
    Given a test app with the default configuration
    And the remote server is cleared
    And a successfully deployed TYPO3 application

  Scenario: Running one time
    And I extend the development capistrano configuration from the fixture file cli_test_tasks.rb
    When I successfully run `cap dev typo3:cms:cli:break_after_one_run`
    Then the output from "cap dev typo3:cms:cli:break_after_one_run" should contain "Running cli task for the 1. time"
    And the output from "cap dev typo3:cms:cli:break_after_one_run" should not contain "Running cli task for the 2. time"
    And the output from "cap dev typo3:cms:cli:break_after_one_run" should contain "Breaking loop after 1 run because block yields false"

  Scenario: Running several times
    And I extend the development capistrano configuration from the fixture file cli_test_tasks.rb
    When I successfully run `cap dev typo3:cms:cli:break_after_three_runs`
    Then the output from "cap dev typo3:cms:cli:break_after_three_runs" should contain "Running cli task for the 1. time"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should contain "Running cli task for the 2. time"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should contain "Running cli task for the 3. time"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should contain "Maximum number of cli calls reached!"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should not contain "Breaking loop after 1 run because block yields false"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should not contain "Breaking loop after 2 run because block yields false"
    And the output from "cap dev typo3:cms:cli:break_after_three_runs" should not contain "Breaking loop after 3 run because block yields false"

  Scenario: Running one time in release path
    And I extend the development capistrano configuration from the fixture file cli_break_after_one_run_in_release_path.rb
    When I successfully run `cap dev deploy`
    Then the output from "cap dev deploy" should contain "Running cli task for the 1. time"
    And the output from "cap dev deploy" should not contain "Running cli task for the 2. time"
    And the output from "cap dev deploy" should contain "Breaking loop after 1 run because block yields false"

  Scenario: Running several times in release path
    And I extend the development capistrano configuration from the fixture file cli_break_after_three_runs_in_release_path.rb
    When I successfully run `cap dev deploy`
    Then the output from "cap dev deploy" should contain "Running cli task for the 1. time"
    And the output from "cap dev deploy" should contain "Running cli task for the 2. time"
    And the output from "cap dev deploy" should contain "Running cli task for the 3. time"
    And the output from "cap dev deploy" should contain "Maximum number of cli calls reached!"
    And the output from "cap dev deploy" should not contain "Breaking loop after 1 run because block yields false"
    And the output from "cap dev deploy" should not contain "Breaking loop after 2 run because block yields false"
    And the output from "cap dev deploy" should not contain "Breaking loop after 3 run because block yields false"

  Scenario: Checking injected environment variables
    And I extend the development capistrano configuration from the fixture file cli_test_tasks_variable_injection.rb
    When I successfully run `cap dev typo3:cms:cli:run`
    Then the output from "cap dev typo3:cms:cli:run" should contain "CUSTOM_VARIABLE=1"

  Scenario: Checking injected environment variables in release path
    And I extend the development capistrano configuration from the fixture file cli_test_tasks_with_path.rb
    When I successfully run `cap dev deploy`
    And the output should contain "CUSTOM_VARIABLE=1"
