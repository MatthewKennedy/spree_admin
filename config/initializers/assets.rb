Rails.application.config.assets.precompile << "spree_admin_manifest.js"

Rails.application.config.assets.paths << Rails.root.join("node_modules/animate.css")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap/scss")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/font")
Rails.application.config.assets.paths << Rails.root.join("node_modules/bootstrap-icons/icons")
Rails.application.config.assets.paths << Rails.root.join("node_modules/flatpickr/dist")
Rails.application.config.assets.paths << Rails.root.join("node_modules/@spree/admin/app/assets/stylesheets/spree/backend")
Rails.application.config.assets.paths << Rails.root.join("node_modules/tinymce")
Rails.application.config.assets.paths << Rails.root.join("node_modules/tom-select/dist/scss")

Rails.application.config.assets.configure do |env|
  env.export_concurrent = false
   Rails.application.config.active_record.yaml_column_permitted_classes = [Symbol, BigDecimal, ActiveSupport::HashWithIndifferentAccess]
end
