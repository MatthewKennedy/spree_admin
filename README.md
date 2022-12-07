[![CI](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/ci.yml)
[![Standard RB](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardrb.yml)
[![Standard JS](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/standardjs.yml)
[![StyleLint](https://github.com/MatthewKennedy/spree_admin/actions/workflows/stylelint.yml/badge.svg)](https://github.com/MatthewKennedy/spree_admin/actions/workflows/stylelint.yml)
# Spree Admin

A fresh take on an Admin UI for Spree, this is currently intended to be experimental and should not be used for production Spree applications.

Spree Admin is free of legacy dependencies and constraints. The goal is to speed up development and find new intuitive ways of using Spree Admin while
completely modernizing the tech stack and user experience.


## Benefits

- Product Images can be tagged to their applicable option(s).
- New order process, more akin to building an invoice than attempting to replicate a shopping cart in an admin UI (WIP).
- Modern UI (WIP).
- Adaptive Light/Dark modes.


## Installation

Starting with a freshly generated Rails 7 app, add the following gems to your Gemfile:

```ruby
# USE THESE FOR NOW...
gem 'spree',             github: 'MatthewKennedy/spree',             branch: 'custom/spree_admin'
gem 'spree_admin',       github: 'MatthewKennedy/spree_admin',       branch: 'main'
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

### Import Javascript from NPM - (OPTIONAL)

If you are using NPM to manage your javascript and want to import the javascript via node_modules run:
```bash
yarn add @matthewkennedy/spree-admin
```
And then create a new file in `app/javascript` called `spree_admin.js` and then import `import '@matthewkennedy/spree-admin'`.


## The Tech Stack

- All ES6 Vanilla JavaScript.
- SASS/SCSS and JavaScript compiled by Rollup.
- Uses the Rails Hotwire ecosystem where ever possible.
- Bootstrap 5


## Development strategy for JavaScript & CSS

The idea is to utilize as much of the Rails Hotwire ecosystem as possible while adding as little custom JavaScript
and relying on as few external JavaScript libraries as possible (as hard as this may be).
Try to build out from Stimulus controller where you can, Stimulus automatically listen to DOM changes
from Turbo getting you a lot for free.

When it comes to the CSS try to write as little CSS as you can, if there is an existing Bootstrap utility class or component, use it, also try to
use CSS variables where ever possible, avoid using SASS variables, doing this will result in a UI that is more adaptive at runtime.

Why Bootstrap when everyone is using Tailwind CSS? I hear you cry. Well this may change, but Tailwind is only a viable option when compiled to remove any unused CSS in production,
this might create problems for extensions that want to use any Tailwind utilities that have not been used in the main Spree Admin, more consideration is needed.


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


## ToDo

- [x] Add dark mode
- [x] Tidy up CSS
- [x] Fix Discount Codes
- [ ] Fix Order Workflow
- [x] Fix Flash Notice
