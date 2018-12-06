# dkdeploy-typo3-cms CHANGELOG

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [8.1.0] - 2018-12-06 
### Summary

- support for Ruby 2.5
- add support for typo3_console task "extension:setupactive"
- adjust typo3 variable for TYPO3 8.7 compatibility
- use remote_web_root_path for path construction

## [8.0.0] - 2018-02-09
### Summary

- rubocop upgrade to 0.50
- ruby upgrade to 2.2
- bundler upgrade
- rake upgrade
- dkdeploy-test_environment upgrade to 2.0
- dkdeploy-core upgrade 9.0
- dkdeploy-php upgrade 8.0
- Add dependencies for `cucumber`, `rubocop`, `aruba` and `mysql2`
- upgrade vagrant box to `ubuntu/xenial64`
- update TYPO3 8.7
- dropped support for TYPO3 7.6
- moving deploy tasks from step_definitions/typo3.rb to deploy.rb for the testing 
- Add TYPO3 specific configuration for assets and database

## [7.0.0] - 2017-01-16
### Summary

- first public release

[Unreleased]: https://github.com/dkdeploy/dkdeploy-typo3-cms/compare/master...develop
[8.1.0]: https://github.com/dkdeploy/dkdeploy-typo3-cms/releases/tag/v8.1.0
[8.0.0]: https://github.com/dkdeploy/dkdeploy-typo3-cms/releases/tag/v8.0.0
[7.0.0]: https://github.com/dkdeploy/dkdeploy-typo3-cms/releases/tag/v7.0.0
