unless defined?(Spree::InstallGenerator)
  require "generators/spree/install/install_generator"
end

require "generators/spree/dummy/dummy_generator"
require "generators/spree/dummy_model/dummy_model_generator"

desc "Generates a dummy app for testing"
namespace :spree_admin do
  task :test_app, :user_class do |_t, args|
    args.with_defaults(user_class: "Spree::LegacyUser", install_storefront: "false", install_admin: "false")
    require ENV["LIB_NAME"].to_s

    ENV["RAILS_ENV"] = "test"
    Rails.env = "test"

    Spree::DummyGenerator.start ["--lib_name=#{ENV["LIB_NAME"]}", "--quiet"]

    Spree::InstallGenerator.start [
      "--lib_name=#{ENV["LIB_NAME"]}",
      "--auto-accept",
      "--migrate=false",
      "--seed=false",
      "--sample=false",
      "--quiet",
      "--copy_storefront=false",
      "--install_storefront=#{args[:install_storefront]}",
      "--install_admin=#{args[:install_admin]}",
      "--user_class=#{args[:user_class]}"
    ]

    $stdout.puts "Setting up dummy database..."
    system("bin/rails db:environment:set RAILS_ENV=test")
    system("bundle exec rake db:drop db:create")
    Spree::DummyModelGenerator.start
    system("bundle exec rake db:migrate")

    unless ["spree/api", "spree/core", "spree/sample", "spree/emails"].include?(ENV["LIB_NAME"])
      $stdout.puts "Setting up node environment"
      system("bin/rails javascript:install:esbuild")
      system("bin/rails turbo:install")
    end

    unless ["spree/api", "spree/core", "spree/sample"].include?(ENV["LIB_NAME"])
      if ENV["LIB_NAME"] == "spree/admin"
        $stdout.puts "Installing Spree Admin node dependencies..."

        if ENV["CI_NAME"] == "CIRCLE_CI"
          system("ls")
        else
          system("yarn add file:../../spree_admin")
        end

        $stdout.puts "Adding Spree Admin assets after @Spree/admin is installed by yarn..."
        ENV["RAILS_ENV"] = "development"

        system("bin/rails g spree:backend:install")

        ENV["RAILS_ENV"] = "test"
      end

      $stdout.puts "Precompiling assets..."
      system("bundle exec rake assets:precompile")
    end
  end

  task :seed do |_t|
    $stdout.puts "Seeding ..."
    system("bundle exec rake db:seed RAILS_ENV=test")
  end
end
