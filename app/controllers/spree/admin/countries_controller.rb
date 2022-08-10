module Spree
  module Admin
    class CountriesController < ResourceController
      private

      def collection
        super.order(:name)
      end

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def location_after_save
        spree.edit_admin_country_path(@object)
      end
    end
  end
end
