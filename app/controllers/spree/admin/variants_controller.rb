module Spree
  module Admin
    class VariantsController < ResourceController
      include Spree::Admin::ProductConcern

      belongs_to "spree/product", find_by: :slug
      new_action.before :new_before
      before_action :redirect_on_empty_option_values, only: [:new]
      before_action :load_data, only: [:new, :create, :edit, :update]

      def destroy
        @object = parent.variants.find(params[:id])
        super
      end

      protected

      def new_before
        master = @object.product.master
        @object.attributes = master.attributes.except(
          "id", "created_at", "deleted_at", "sku", "is_master"
        )

        # Shallow Clone of the default price to populate the price field.
        @object.default_price = master.default_price.clone if master.default_price.present?
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @deleted = params[:q].delete(:deleted_at_null) || "0"
        @collection = super
        @collection = @collection.deleted if @deleted == "1"
        # @search needs to be defined as this is passed to search_link
        @search = @collection.ransack(params[:q])
        @collection = @search.result
          .page(params[:page])
          .per(params[:per_page] || Spree::Backend::Config[:variants_per_page])
      end

      private

      def load_data
        @tax_categories = TaxCategory.order(:name)
      end

      def collection_url
        spree.edit_admin_product_path(params[:product_id])
      end

      def redirect_on_empty_option_values
        redirect_to spree.admin_product_variants_url(params[:product_id]) if @product.empty_option_values?
      end
    end
  end
end
