module Spree
  module Backend
    module Generators
      class InstallGenerator < Rails::Generators::Base
        desc "Installs Spree Dash"

        def self.source_paths
          [
            File.expand_path("templates", __dir__),
            File.expand_path("../templates", "../#{__FILE__}"),
            File.expand_path("../templates", "../../#{__FILE__}")
          ]
        end

        def install
          template "app/assets/stylesheets/spree/backend/admin.scss"
          unless ENV["SPREE_ADMIN_SKIP_INSTALL_NODE_JS_FILES"] == "true"
            template "app/javascript/spree_admin.js"
            template "vendor/assets/stylesheets/spree/backend/all.css"
          end
        end
      end
    end
  end
end
