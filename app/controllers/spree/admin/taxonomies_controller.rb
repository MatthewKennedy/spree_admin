module Spree
  module Admin
    class TaxonomiesController < ResourceController
      private

      def location_after_save
        if @taxonomy.previously_new_record?
          spree.edit_admin_taxonomy_url(@taxonomy)
        else
          spree.admin_taxonomies_url
        end
      end
    end
  end
end
