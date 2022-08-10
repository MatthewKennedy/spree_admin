require "rubygems"
require "rake"
require "rake/testtask"
require "rspec/core/rake_task"
require "spree/backend/testing_support/spree_dash_rake"

RSpec::Core::RakeTask.new

task default: :spec

desc "Generates a dummy app for testing"
task :test_app do
  ENV["LIB_NAME"] = "spree/backend"
  Rake::Task["spree_admin:test_app"].execute({install_admin: true, install_storefront: false})
end
