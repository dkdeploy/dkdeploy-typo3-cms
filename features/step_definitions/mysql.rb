Given(/^the TYPO3 table be_users exists$/) do
  mysql_client = instantiate_mysql_client @database_name
  mysql_client.query 'DROP TABLE IF EXISTS be_users;'
  mysql_client.query "CREATE TABLE be_users (
                                    uid int(11) unsigned NOT NULL auto_increment,
                                    pid int(11) unsigned DEFAULT '0' NOT NULL,
                                    tstamp int(11) unsigned DEFAULT '0' NOT NULL,
                                    username varchar(50) DEFAULT '' NOT NULL,
                                    description varchar(2000) DEFAULT '' NOT NULL,
                                    avatar int(11) unsigned NOT NULL default '0',
                                    password varchar(100) DEFAULT '' NOT NULL,
                                    admin tinyint(4) unsigned DEFAULT '0' NOT NULL,
                                    usergroup varchar(255) DEFAULT '' NOT NULL,
                                    disable tinyint(1) unsigned DEFAULT '0' NOT NULL,
                                    starttime int(11) unsigned DEFAULT '0' NOT NULL,
                                    endtime int(11) unsigned DEFAULT '0' NOT NULL,
                                    lang varchar(6) DEFAULT '' NOT NULL,
                                    email varchar(80) DEFAULT '' NOT NULL,
                                    db_mountpoints text,
                                    options tinyint(4) unsigned DEFAULT '0' NOT NULL,
                                    crdate int(11) unsigned DEFAULT '0' NOT NULL,
                                    cruser_id int(11) unsigned DEFAULT '0' NOT NULL,
                                    realName varchar(80) DEFAULT '' NOT NULL,
                                    userMods text,
                                    allowed_languages varchar(255) DEFAULT '' NOT NULL,
                                    uc mediumblob,
                                    file_mountpoints text,
                                    file_permissions text,
                                    workspace_perms tinyint(3) DEFAULT '1' NOT NULL,
                                    lockToDomain varchar(50) DEFAULT '' NOT NULL,
                                    disableIPlock tinyint(1) unsigned DEFAULT '0' NOT NULL,
                                    deleted tinyint(1) unsigned DEFAULT '0' NOT NULL,
                                    TSconfig text,
                                    lastlogin int(10) unsigned DEFAULT '0' NOT NULL,
                                    createdByAction int(11) DEFAULT '0' NOT NULL,
                                    usergroup_cached_list text,
                                    workspace_id int(11) DEFAULT '0' NOT NULL,
                                    workspace_preview tinyint(3) DEFAULT '1' NOT NULL,
                                    category_perms text,
                                    PRIMARY KEY (uid),
                                    KEY parent (pid),
                                    KEY username (username)
                      );"
end

# From TYPO3 CMS V6 Gem:
Given(/a TYPO3 backend user "(.*)" exists$/) do |username|
  mysql_client = instantiate_mysql_client @database_name
  mysql_client.query "INSERT INTO `be_users` (username, admin, crdate, tstamp)
          VALUES
            ('#{mysql_client.escape(username)}', 0, UNIX_TIMESTAMP(), UNIX_TIMESTAMP());"
end

Given(/^the database table `(.*)` exists$/) do |table|
  mysql_client = instantiate_mysql_client @database_name
  mysql_client.query "DROP Table IF EXISTS #{mysql_client.escape(table)};"
  mysql_client.query "CREATE TABLE #{mysql_client.escape(table)} (
                                   uid  INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY
                      );"
end

Given(/^drop the database table `(.*)`/) do |table|
  mysql_client = instantiate_mysql_client @database_name
  mysql_client.query "DROP Table #{mysql_client.escape(table)};"
end

Then(/^the database (should|should not) have a table `(.*)`$/) do |should_or_not, table|
  mysql_client = instantiate_mysql_client
  query_string = "SELECT `TABLE_NAME`
                    FROM `information_schema`.`TABLES`
                   WHERE `TABLE_SCHEMA` = '#{mysql_client.escape(@database_name)}'
                     AND `TABLE_NAME` = '#{mysql_client.escape(table)}';"
  results = mysql_client.query query_string
  number_of_columns = results.count
  expectation = should_or_not == 'should' ? 1 : 0
  expect(number_of_columns).to eq expectation
end
