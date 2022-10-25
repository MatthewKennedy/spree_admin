[![CI](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml)

# Omes Admin

An alternative Admin UI for Spree

## Tech Stack Benefits

- jQuery Free
- No compiling SCSS or Javascript through Sprockets
- Uses Stimulus and Turbo

## User Benefits

- Product Images can be tagged to the applicable options
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP)
-

### What Is The Difference Between Omes Admin and Spree Backend?

Omes Admin is a fresh take on an Admin UI for Spree, it is currently intended to be experimental in the early stages, free from any legacy dependencies, being locked-into
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

Install the Spree Admin javascript bundle
```bash
   yarn add "@omes/admin"
```

Add to your project the path to load bootstrap SVG icons from node_modules

```javascript
//In -> app/assets/config/manifest.js

//= link_tree ../../../node_modules/bootstrap-icons/icons .svg
```


### Development Setup (JavaScript)

When working locally on the JavaScript in Omes Admin, you will need to yarn link your local development copy of `@omes/admin`, to the Rails app you are working in, so that your changes are picked up and represented live in the view.

From the root of `spree_admin` run:

```bash
yarn link
```

Next, from the root of the Rails app you are using to develop run:

```bash
yarn link "@omes/admin"
```

Once your local Spree Dashboard is linked with the Rails app you are using for development you will need two terminal tabs open,
one at the root of your Rails app, and one at the root of `spree_admin`.

In the terminal window at the root of the `spree_admin` run:

```bash
yarn watch:js
```

And from the Rails app you are using to run Spree and develop in run the following:

```bash
bin/dev
```

Any changes made to the JavaScript files in `spree_admin` will be processed by yarn and picked up in the Rails app you are running for development.

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
