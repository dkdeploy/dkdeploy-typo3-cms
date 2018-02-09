![dkdeploy](assets/dkdeploy-logo.png)

# Dkdeploy::Typo3::Cms

[![Build Status](https://travis-ci.org/dkdeploy/dkdeploy-typo3-cms.svg?branch=master)](https://travis-ci.org/dkdeploy/dkdeploy-typo3-cms)
[![Gem Version](https://badge.fury.io/rb/dkdeploy-typo3-cms.svg)](https://badge.fury.io/rb/dkdeploy-typo3-cms) [![Inline docs](http://inch-ci.org/github/dkdeploy/dkdeploy-typo3-cms.svg?branch=develop)](http://inch-ci.org/github/dkdeploy/dkdeploy-typo3-cms)

## Description

dkdeploy-typo3-cms ruby gem represents the extension of [Capistrano](http://capistranorb.com/) tasks directed to the advanced deployment process.

## Installation

Add this line to your application's `Gemfile`

	gem 'dkdeploy-typo3-cms', '~> 8.0'

and then execute

	bundle install

or install it yourself as

	gem install dkdeploy-typo3-cms

## Usage

Run in your project root

	cap install STAGES='dev,integration,testing,production'

This command will create the following Capistrano file structure with all the standard pre-configured constants.
Please be aware of the difference to the [native installation](http://capistranorb.com/documentation/getting-started/preparing-your-application/) of Capistrano.
Certainly you have to adjust `config/deploy.rb` and respective stages and customize them for your needs.

<pre>
  ├── Capfile
  └── config
     ├── deploy
     │   ├── dev.rb
     │   ├── integration.rb
     │   ├── testing.rb
     │   └── production.rb
     └── deploy.rb
</pre>

As next you have to append the following line to the `Capfile` in order to make use of dkdeploy extensions in addition to the standard Capistrano tasks:

	require 'capistrano/dkdeploy/typo3_cms'

To convince yourself, that Capistrano tasks list has benn extended, please run

	cap -vT

Please note, that dkdeploy uses the local copy strategy and overwrites the `:scm` constant. If you want to use it,
you should do nothing more. However if you want to change it for example to `:git`, please add the following line to `deploy.rb`

	set :scm, :git

For more information about available Capistrano constants please use the [Capistrano documentation](http://capistranorb.com/documentation/getting-started/preparing-your-application/).
The complete list of the dkdeploy constants you find in `/lib/capistrano/dkdeploy` in # TODO: set link

## Testing

### Prerequisite

Add the virtual box alias to your `hosts` file

	192.168.156.183 dkdeploy-typo3-cms.dev

### Running tests

1. Start the local box (`vagrant up --provision`)
2. Check coding styles (`rubocop`)
3. Run BDD cucumber tests (`cucumber`)

## Contributing

1. Install [git flow](https://github.com/nvie/gitflow)
2. Install [Homebrew](http://brew.sh/) and run `brew install mysql`
3. If project is not checked out already do git clone `git@github.com:dkdeploy/dkdeploy-typo3-cms.git`
4. Checkout origin develop branch (`git checkout --track -b develop origin/develop`)
5. Git flow initialize `git flow init -d`
6. Installing gems `bundle install`
7. Create new feature branch (`git flow feature start my-new-feature`)
8. Run tests (README.md Testing)
9. Commit your changes (`git commit -am 'Add some feature'`)
