[![CI](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml)

# Spree Admin

An alternative Admin UI for Spree.

## Tech Stack Benefits

- jQuery Free
- SASS/SCSS and JavaScript all compiled by modern processors, not Sprockets.
- Uses Stimulus and Turbo


## User Benefits

- Product Images can be tagged to the applicable options
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP)
- Modern UI


### What Is The Difference Between Spree Admin and Spree Backend?

Spree Admin is a fresh take on an Admin UI for Spree, it is currently intended to be experimental in the early stages, free from any legacy dependencies, being locked-into
working with old Spree extensions, old Rails versions, or large Spree apps that rely heavily on Spree Backend.

The goal is that we can move fast and fluid find new intuitive ways of using Spree Admin.


### What About The Javascript?
You might be pleased to know we have completely stripped out all the old JavaScript, reducing the dependency on 3rd party libraries to a minimum,
no more jQuery, no more Select2.

All new JavaScript is written in Stimulus controllers so it is all Hotwire/Turbo friendly.


## Installation

Starting with a freshly generated Rails 7 app using esbuild simply add the following gems to your gem file:
```ruby
# USE THESE TEMP
gem 'spree', github: 'MatthewKennedy/spree', branch: 'custom/spree_admin'
gem 'spree_admin', github: 'MatthewKennedy/spree_admin'
gem 'spree_auth_devise', github: 'MatthewKennedy/spree_auth_devise', branch: 'custom/spree_admin'
```

From the command line run the following commands to:

Install Spree
```bash
   bin/rails g spree:install --user_class=Spree::User
```

Install Spree Auth Devise
```bash
   bin/rails g spree:auth:install
```

Install Spree Admin
```bash
   bin/rails g spree:backend:install
```

### Use @omes/admin NPM - OPTIONAL
If you are using NPM to manage your javascript and want to import the javascript via node_modules run:
```bash
   yarn add "@omes/admin"
```
And then create a new file in `app/javascript` called `spree_admin.js` and then import `import '@omes/admin'`.


## Development Setup (JavaScript, SCSS)

From the root of `spree_admin` run:

```bash
yarn watch
```

And from the Rails app you are using to run Spree and develop in run the following:

```bash
bin/dev
```

### Local setup

1. Fork it!
2. Clone the repository
3. Create test application:

   ```bash
   cd spree_admin
   bundle install
   bundle exec rake test_app
   ```

### Running tests

Entire test suite (this can take some time!)

```bash
bundle exec rspec
```

Single test file:

```bash
bundle exec rspec spec/features/admin/users_spec.rb
```

[ChromeDriver](https://chromedriver.chromium.org/) is required for feature tests. On MacOS you can install it by running:

```bash
brew install chromedriver
```
