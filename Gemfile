source "https://rubygems.org"

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw]

%w[
  actionmailer actionpack actionview activejob activemodel activerecord
  activestorage activesupport railties
].each do |rails_gem|
  gem rails_gem, ENV.fetch("RAILS_VERSION", "~> 7.0.0"), require: false
end

platforms :jruby do
  gem "jruby-openssl"
end

platforms :ruby do
  if ENV["DB"] == "mysql"
    gem "mysql2"
  else
    gem "pg", "~> 1.1"
  end
end

group :test do
  gem "capybara"
  gem "capybara-screenshot", "~> 1.0"
  gem "database_cleaner", "~> 2.0"
  gem "email_spec"
  gem "factory_bot_rails", "~> 6.0"
  gem "jsonapi-rspec"
  gem "multi_json"
  gem "propshaft"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks", "~> 1.0"
  gem "rspec_junit_formatter"
  gem "rspec-rails", "~> 6.0"
  gem "rspec-retry"
  gem "rswag-specs"
  gem "simplecov", "0.21.2"
  gem "timecop"
  gem "webmock", "~> 3.7"
end

group :test, :development do
  gem "appraisal"
  gem "awesome_print"
  gem "ffaker"
  gem "gem-release"
  gem "i18n-tasks"
  gem "pry-byebug"
  gem "puma", "~> 6.1"
  gem "redis"
  gem "rubocop", "1.26.0"
  gem "standard", "1.9.0"
  gem "webdrivers", "~> 5.0"
end

group :development do
  gem "solargraph"
  gem "erb_lint"
end

spree_opts = {github: "spree/spree", branch: "main"}
gem "spree_api", spree_opts
gem "spree_core", spree_opts

gemspec
