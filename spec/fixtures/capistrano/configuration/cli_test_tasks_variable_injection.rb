# frozen_string_literal: true

set :path_to_typo3_cli, File.join('catalog', 'variable_injection_test.phpsh')

set :typo3_environment_cli, {
  CUSTOM_VARIABLE: 1
}
