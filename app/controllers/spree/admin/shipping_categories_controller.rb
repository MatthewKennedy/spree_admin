module Spree
  module Admin
    class ShippingCategoriesController < ResourceController
      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end
    end
  end
end
