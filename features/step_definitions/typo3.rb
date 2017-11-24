Given(/^a successfully deployed TYPO3 application$/) do
  step 'I want to use the database `dkdeploy_typo3_cms`'
  step 'the TYPO3 table be_users exists'
  step 'a TYPO3 backend user "_cli_" exists'
  step 'I successfully run `cap dev composer:local:run[install]` for up to 60 seconds'
  step 'I successfully run `cap dev db:upload_settings[127.0.0.1,3306,dkdeploy_typo3_cms,root,ilikerandompasswords,utf8]`'
  step 'I successfully run `cap dev typo3:cms:create_db_credentials`'
  step 'I successfully run `cap dev typo3:cms:create_install_tool_password_file[dkdeploy]`'
  step 'I successfully run `cap dev typo3:cms:create_encryption_key_file[ca01b5b9868677647d3ec6c91b6b338a34786d6d4e163fb44badde98d11c9f887a5567a1d7797847de011693c36e110f]`'
  step 'I successfully run `cap dev deploy`'
  step 'I successfully run `cap dev typo3:cms:update_database`'
end
