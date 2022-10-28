module Spree
  module Backend
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Installs Spree Admin"

        def self.source_paths
          [
            File.expand_path("templates", __dir__),
            File.expand_path("../templates", "../#{__FILE__}"),
            File.expand_path("../templates", "../../#{__FILE__}")
          ]
        end

        def install
          # template "app/assets/config/manifest.js", force: true if Rails.env == "test"
          template "vendor/assets/stylesheets/spree/backend/all.css"

          unless ENV["SPREE_ADMIN_SKIP_INSTALL_NODE_JS_FILES"] == "true"
            template "app/javascript/spree_admin.js"
          end
        end
      end
    end
  end
end
