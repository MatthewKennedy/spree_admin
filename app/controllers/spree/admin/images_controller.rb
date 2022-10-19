module Spree
  module Admin
    class ImagesController < ResourceController
      before_action :load_product
      before_action :load_edit_data, except: :index

      create.before :set_viewable
      update.before :set_viewable

      private

      def location_after_destroy
        spree.admin_product_images_url(@product)
      end

      def load_edit_data
        @variants = @product.variants
        @option_values = []
        @option_value_ids = []

        @variants.each do |variant|
          variant.option_values.each do |ov|
            # TEMP catch for old spree vs new spree.
            if ov.option_type.has_attribute?(:image_filter)
              next unless ov.option_type.image_filter
            end

            @option_values << ov
          end
        end

        @option_values.uniq!

        @option_value_ids = @option_values.map(&:id)
      end

      def set_viewable
        @image.viewable_type = "Spree::Variant"
        @image.viewable_id = @product.master_id
      end

      def load_product
        @product = scope.friendly.find(params[:product_id])
      end

      def scope
        current_store.products
      end

      def location_after_save
        spree.edit_admin_product_path(@product)
      end

      def collection_url
        spree.admin_product_images_url
      end

      def model_class
        Spree::Image
      end

      def collection
        @collection ||= load_product.variant_images
      end
    end
  end
end
