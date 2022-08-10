module Spree
  module Admin
    class ShippingMethodsController < ResourceController
      before_action :load_data, except: :index

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def location_after_save
        spree.edit_admin_shipping_method_path(@shipping_method)
      end

      def load_data
        @available_zones = Zone.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @calculators = ShippingMethod.calculators.sort_by(&:name)
        @categories = ShippingCategory.order(:name)
      end
    end
  end
end
