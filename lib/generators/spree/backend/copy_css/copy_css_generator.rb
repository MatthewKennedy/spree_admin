module Spree
  module Backend
    class CopyCssGenerator < Rails::Generators::Base
      desc "Copies CSS from Spree Admin to your applications vendor directory"

      def self.source_paths
        [File.expand_path("../../../../../", __dir__)]
      end

      def copy_css
        template "app/assets/stylesheets/spree/backend/spree_admin.css", "vendor/assets/stylesheets/spree/backend/spree_admin.css"
      end
    end
  end
end
