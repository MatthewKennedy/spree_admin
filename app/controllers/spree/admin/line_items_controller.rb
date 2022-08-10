module Spree
  module Admin
    class LineItemsController < ResourceController
      include Spree::Admin::OrderConcern
      before_action :load_order, only: [:create]
      before_action :load_order_form_line_item, only: [:update, :destroy]

      def create
        @variant = current_store.variants.find(permitted_resource_params[:variant_id])

        result = add_item_service.call(
          order: @order,
          variant: @variant,
          quantity: permitted_resource_params[:quantity]
        )

        if result.success?
          rebuild_order

          redirect_back fallback_location: spree.edit_admin_order_url(@order)
        else
          flash[:error] = result.error.to_s
        end
      end

      def update
        result = update_service.call(line_item: @object, line_item_attributes: permitted_resource_params)

        if result.success?
          rebuild_order

          redirect_back fallback_location: spree.edit_admin_order_url(@order)
        else
          flash[:error] = result.error.to_s
        end
      end

      def destroy
        result = destroy_service.call(line_item: @object)

        if result.success?
          rebuild_order

          redirect_back fallback_location: spree.edit_admin_order_url(@order)
        else
          flash[:error] = result.error.to_s
        end
      end

      private

      def rebuild_order
        @order.reload
        @order.update_with_updater!
        @order.create_proposed_shipments
      end

      def load_order_form_line_item
        @order ||= @object.order
      end

      def add_item_service
        Spree::Dependencies.line_item_add_item_service.constantize
      end

      def create_service
        Spree::Dependencies.line_item_create_service.constantize
      end

      def update_service
        Spree::Dependencies.line_item_update_service.constantize
      end

      def destroy_service
        Spree::Dependencies.line_item_destroy_service.constantize
      end

      def permitted_resource_params
        params.require(:line_item).permit(permitted_line_item_attributes)
      end
    end
  end
end
