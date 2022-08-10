# Spree Admin

An alternative Admin UI for Spree

## Key Features

- Mobile-first - works great on any device!
- Manage Product Catalog, Orders, Customers, Returns, Shipments and all other eCommerce crucial activities
- Multi-Store support out of the box
- Built-in CMS for Pages and Navigation
- Easily add 3rd party integrations such as Payments, Tax calculation services and Shipping couriers
- Easy customization to suit your needs
- Modern tech-stack based on [Hotwire](https://hotwired.dev/) (Stimulus & Turbo)

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
   gem "spree"
   gem "spree_admin"
   gem "spree_auth_devise"
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
   yarn add "@spree/admin"
```


### Development Setup (JavaScript)

When working locally on the JavaScript in Spree Admin, you will need to yarn link your local development copy of `@spree/admin`, to the Rails app you are working in, so that your changes are picked up and represented live in the view.

From the root of `spree_admin` run:

```bash
yarn link
```

Next, from the root of the Rails app you are using to develop run:

```bash
yarn link "@spree/admin"
```

Once your local Spree Dashboard is linked with the Rails app you are using for development you will need two terminal tabs open,
one at the root of your Rails app, and one at the root of `spree_admin`.

In the terminal window at the root of the `spree_admin` run:

```bash
yarn watch
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
