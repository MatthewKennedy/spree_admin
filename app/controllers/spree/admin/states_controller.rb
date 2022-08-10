module Spree
  module Admin
    class StatesController < ResourceController
      belongs_to "spree/country"

      private

      def location_after_save
        spree.edit_admin_country_path(@country)
      end
    end
  end
end
