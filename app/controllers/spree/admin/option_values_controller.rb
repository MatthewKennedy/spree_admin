module Spree
  module Admin
    class OptionValuesController < ResourceController
      belongs_to "spree/option_type"

      def location_after_save
        spree.edit_admin_option_type_url(@option_type)
      end
    end
  end
end
