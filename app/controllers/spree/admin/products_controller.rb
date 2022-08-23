module Spree
  module Admin
    class ProductsController < ResourceController
      include Spree::Admin::ProductConcern
      helper "spree/admin/products"

      before_action :load_data, except: [:index, :bulk_update_status]
      before_action :set_product_defaults, only: :new

      create.before :create_before
      update.before :update_before
      update.before :skip_updating_status
      update.after :update_status

      def filter
        collection
      end

      def bulk_update_status
        @selected_products = Product.where(id: params.fetch(:product_ids, []).compact)

        if params[:button] == "active"
          @selected_products.update_all(status: :active)
        elsif params[:button] == "draft"
          @selected_products.update_all(status: :draft)
        elsif params[:button] == "archive"
          @selected_products.update_all(status: :archived)
        end

        flash[:success] = "#{@selected_products.count} #{I18n.t("spree.admin.products.products_marked_as")} #{params[:button].capitalize}"
        redirect_to action: :index
      end

      def show
        session[:return_to] ||= request.referer
        redirect_to action: :edit
      end

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def update
        if params[:product][:taxon_ids].present?
          params[:product][:taxon_ids] = params[:product][:taxon_ids].reject(&:empty?)
        end
        if params[:product][:option_type_ids].present?
          params[:product][:option_type_ids] = params[:product][:option_type_ids].reject(&:empty?)
        end

        super
      end

      def clone
        @new = @product.duplicate

        if @new.persisted?
          flash[:success] = I18n.t("spree.admin.notice_messages.product_cloned")
          redirect_to spree.edit_admin_product_url(@new)
        else
          flash[:error] = I18n.t("spree.admin.notice_messages.product_not_cloned", error: @new.errors.full_messages.to_sentence)
          redirect_to spree.admin_products_url
        end
      rescue ActiveRecord::RecordInvalid => e
        # Handle error on uniqueness validation on product fields
        flash[:error] = I18n.t("spree.admin.notice_messages.product_not_cloned", error: e.message)
        redirect_to spree.admin_products_url
      end

      def add_stock
        @variant = @product.variants_including_master.find_by(id: params[:variant_id])
        @stock_locations = StockLocation.accessible_by(current_ability)
        if @stock_locations.empty?
          flash[:error] = Spree.t(:stock_management_requires_a_stock_location)
          redirect_to spree.admin_stock_locations_path
        end
      end

      def remove_from_taxon
        @taxon = Taxon.find(params[:taxon_id])

        if @object.taxons.delete(@taxon)
          respond_to do |format|
            format.turbo_stream { render "spree/admin/taxons/remove_from_taxon" }
          end
        else
          stream_flash_alert(message: I18n.t("spree.admin.products.errors.could_not_remove_from_taxon"), kind: :error)
        end
      end

      def update_availability
        if @object.update(status: permitted_resource_params[:status])
        else
          stream_flash_alert(message: I18n.t("spree.admin.products.errors.status_could_not_be_updated"), kind: :error)
        end
      end

      def update_cost_currency
        if @object.update(cost_currency: permitted_resource_params[:cost_currency])
        else
          stream_flash_alert(message: I18n.t("spree.admin.products.errors.cost_currency_could_not_be_updated"), kind: :error)
        end
      end

      def update_promotionable
        if @object.update(promotionable: permitted_resource_params[:promotionable])
        else
          stream_flash_alert(message: I18n.t("spree.admin.products.errors.promotionable_could_not_be_updated"), kind: :error)
        end
      end

      protected

      def find_resource
        product_scope.with_deleted.friendly.find(params[:id])
      end

      def location_after_save
        spree.edit_admin_product_path(@product)
      end

      def load_data
        @taxons = Taxon.order(:name)
        @option_types = OptionType.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)
      end

      def set_product_defaults
        @product.shipping_category ||= @shipping_categories&.first
      end

      def skip_updating_status
        @new_status = params[:product].delete(:status)
      end

      def update_status
        return if @new_status == @product.status
        return if cannot?(:activate, Spree::Product) && @new_status&.to_sym == :active

        event_to_fire = @product.status_transitions.find { |transition| transition.from == @product.status && transition.to == @new_status }&.event
        @product.send(event_to_fire) if event_to_fire
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"

        params[:q][:s] ||= "name asc"

        per_page_limit = params[:per_page] || Spree::Backend::Config[:admin_products_per_page]

        @collection = product_scope

        # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
        # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
        if params[:q][:deleted_at_null] == "0"
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
        # This is to include all products and not just deleted products.
        @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == "deleted_at_null" })
        @collection = @search.result.includes(product_includes)

        @pagy, @collection = pagy(@collection, items: per_page_limit)

        @collection
      end

      def create_before
        return if params[:product][:prototype_id].blank?

        @prototype = Spree::Prototype.find(params[:product][:prototype_id])
      end

      def update_before
        # NOTE: we only reset the product properties if we're receiving a post
        #       from the form on that tab
        return unless params[:clear_product_properties]

        params[:product] ||= {}
      end

      def product_includes
        {
          variant_images: [],
          tax_category: [],
          master: [],
          variants: [:prices]
        }
      end

      def permitted_resource_params
        if cannot?(:activate, @product) && @new_status&.to_sym == :active
          super.except(:status, :make_active_at).permit!
        else
          super
        end
      end

      private

      def variant_stock_includes
        [:images, stock_items: :stock_location, option_values: :option_type]
      end
    end
  end
end
