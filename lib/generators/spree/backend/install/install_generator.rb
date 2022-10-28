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
          template "vendor/assets/stylesheets/spree/backend/all.css"
        end
      end
    end
  end
end
