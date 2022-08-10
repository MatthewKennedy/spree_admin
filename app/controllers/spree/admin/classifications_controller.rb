module Spree
  module Admin
    class ClassificationsController < ResourceController
      private

      def load_resource
        @object ||= Classification.find_by(taxon_id: params[:taxon_id], product_id: params[:product_id])
      end
    end
  end
end
