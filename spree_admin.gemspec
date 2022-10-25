require_relative "lib/spree/backend/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "spree_admin"
  s.version = Spree::Backend.version
  s.authors = ["Matthew Kennedy"]
  s.email = "m.kennedy@me.com"
  s.summary = "Admin for Spree eCommerce platform"
  s.description = "An alternative Admin UI for Spree eCommerce platform."
  s.homepage = "https://github.com/MatthewKennedy/spree_admin"
  s.license = "BSD-3-Clause"

  s.metadata = {
    "bug_tracker_uri" => "https://github.com/MatthewKennedy/spree_admin/issues",
    "changelog_uri" => "https://github.com/MatthewKennedy/spree_admin/releases/tag/v#{s.version}",
    "documentation_uri" => "https://github.com/MatthewKennedy/spree_admin/",
    "source_code_uri" => "https://github.com/MatthewKennedy/spree_admin/tree/v#{s.version}"
  }

  s.required_ruby_version = ">= 2.7"

  s.files = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "babel-transpiler"
  s.add_dependency "inline_svg"
  s.add_dependency "jsbundling-rails"
  s.add_dependency "pagy"
  s.add_dependency "responders"
  s.add_dependency "sass-rails"
  s.add_dependency "spree", ">= 4.4.0"
  s.add_dependency "sprockets"
  s.add_dependency "turbo-rails"
end
