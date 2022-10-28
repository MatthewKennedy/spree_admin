unless defined?(Spree::InstallGenerator)
  require "generators/spree/install/install_generator"
end

require "generators/spree/dummy/dummy_generator"
require "generators/spree/dummy_model/dummy_model_generator"

desc "Generates a dummy app for testing"
namespace :spree_admin do
  task :test_app, :user_class do |_t, args|
    args.with_defaults(user_class: "Spree::LegacyUser")
    require ENV["LIB_NAME"].to_s

    ENV["RAILS_ENV"] = "test"
    ENV["DUMMY_PATH"] = "tmp/dummy"

    Rails.env = "test"

    $stdout.puts "(1) Building dummy app for testing #{ENV["LIB_NAME"]}"
    Spree::DummyGenerator.start ["--lib_name=#{ENV["LIB_NAME"]}", "--quiet"]
    Spree::InstallGenerator.start [
      "--lib_name=#{ENV["LIB_NAME"]}",
      "--auto-accept",
      "--migrate=false",
      "--seed=false",
      "--sample=false",
      "--quiet",
      "--user_class=#{args[:user_class]}"
    ]

    $stdout.puts "(2) Setting up dummy database..."
    system("bin/rails db:environment:set RAILS_ENV=test")
    system("bundle exec rake db:drop db:create")
    Spree::DummyModelGenerator.start
    system("bundle exec rake db:migrate")

    $stdout.puts "(3) Bundling ..."
    system("bundle install")

    $stdout.puts "(4) Running spree:backend:install ..."
    system("bin/rails g spree:backend:install")

    $stdout.puts "(5) Precompiling assets..."
    system("bundle exec rake assets:precompile")
  end
end
