Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile << "spree_admin_manifest.js"
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/icons")

Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
end
