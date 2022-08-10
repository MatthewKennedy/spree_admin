module Spree
  module Admin
    class ProductPropertiesController < ResourceController
      belongs_to "spree/product", find_by: :slug
      before_action :setup_property, only: :index
      before_action :find_product, only: [:prototypes, :prototype_properties]

      def prototypes
        @prototypes ||= Prototype.order("name asc")
      end

      def prototype_properties
        @prototype ||= Prototype.find(params[:prototype_id])
        @prototype_properties = @prototype.properties

        respond_with(@prototype_properties) do |format|
          format.turbo_stream
        end
      end

      private

      def find_product
        @product ||= Product.find_by(slug: params[:product_id])
      end

      def setup_property
        @product.product_properties.build
      end

      def location_after_save
        spree.edit_admin_product_path(@product)
      end
    end
  end
end
