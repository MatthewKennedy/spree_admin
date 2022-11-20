module Spree
  module Admin
    class StockItemsController < Spree::Admin::BaseController
      before_action :determine_backorderable, only: :update

      def update
        if stock_item.save
          variant = stock_item.variant

          flash_message_for(stock_item, :successfully_updated)

          if variant.is_master?
            redirect_to spree.edit_admin_product_path(variant.product)
          else
            redirect_to spree.edit_admin_product_variant_path(variant.product, variant)
          end
        else
          dispatch_notice(Spree.t(:could_not_update_stock_item), :error)
        end
      end

      def create
        variant = current_store.variants.find(params[:stock_movement][:variant_id])
        stock_location = StockLocation.find(params[:stock_movement][:stock_location_id])
        stock_movement = stock_location.stock_movements.build(stock_movement_params)
        stock_movement.stock_item = stock_location.set_up_stock_item(variant)

        if stock_movement.save
          flash_message_for(stock_movement, :successfully_created)
          if variant.is_master?
          end
          redirect_to spree.edit_admin_product_path(variant.product)
        else
          dispatch_notice(Spree.t(:could_not_create_stock_movement), :error)
        end
      end

      def destroy
        stock_item.destroy
      end

      private

      def stock_movement_params
        params.require(:stock_movement).permit(permitted_stock_movement_attributes)
      end

      def stock_item
        @stock_item ||= current_store.stock_items.find(params[:id])
      end

      def determine_backorderable
        stock_item.backorderable = params[:stock_item].present? && params[:stock_item][:backorderable].present?
      end
    end
  end
end
