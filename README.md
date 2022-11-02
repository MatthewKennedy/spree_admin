[![CI](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml)

# Spree Admin

Spree Admin is a fresh take on an Admin UI for Spree, it is currently intended to be experimental in the early stages,
free from any legacy dependencies. The goal is to speed up development and find new intuitive ways of using Spree Admin.


## User Benefits

- Product Images can be tagged to the applicable options.
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP).
- Modern UI (WIP).


## Tech Stack Benefits

- All ES6 Vanilla JavaScript.
- SASS/SCSS and JavaScript compiled by modern processors.
- Uses Stimulus and Turbo where ever possible.
- Bootstrap 5


## Installation

Starting with a freshly generated Rails 7 app, add the following gems to your Gemfile:

```ruby
# USE THESE TEMP
gem 'spree',                github: 'MatthewKennedy/spree',             branch: 'custom/spree_admin'
gem 'spree_admin',          github: 'MatthewKennedy/spree_admin',       branch: 'main'
gem 'spree_auth_devise',    github: 'MatthewKennedy/spree_auth_devise', branch: 'custom/spree_admin'
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


### Use Javascript from NPM package - (OPTIONAL)

If you are using NPM to manage your javascript and want to import the javascript via node_modules run:
```bash
   yarn add @matthewkennedy/spree_admin
```
And then create a new file in `app/javascript` called `spree_admin.js` and then import `import '@matthewkennedy/spree_admin'`.


## Development Setup (JavaScript, SCSS)

The idea is to utilize as much of the Rails Hotwire setup as possible -> (Turbo Frames, Turbo Streams & Stimulus) while adding as little custom JavaScript
and relying on as few external JavaScript libraries as possible (as hard as this may be).
Try to build out from Stimulus controller where you can, Stimulus automatically listen to DOM changes
from Turbo getting you a lot for free.

When it comes to the CSS try to write as little CSS as you can, if there is an existing Bootstrap utility class or component, use it, also try to
use CSS variables where ever possible, avoid using SASS variables, doing this will result in a UI that is more adaptive at runtime.


### Run in Dev Mode

From the root of `spree_admin` run:

```bash
yarn watch
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
