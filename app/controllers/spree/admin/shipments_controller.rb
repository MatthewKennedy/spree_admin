module Spree
  module Admin
    class ShipmentsController < ResourceController
      SHIPMENT_STATES = %w[ready ship cancel resume pend]

      def edit_tracking_number
        render "spree/admin/orders/shipments/edit_tracking_number"
      end

      def update
        result = update_service.call(shipment: @shipment, shipment_attributes: permitted_resource_params)

        if result.success?
          redirect_back fallback_location: location_after_save
        else
          flash[:error] = result.error.to_s
        end
      end

      def add_item
        result = add_item_service.call(
          shipment: @shipment,
          variant_id: params.dig(:shipment, :variant_id),
          quantity: params.dig(:shipment, :quantity)
        )

        if result.success?
          redirect_back fallback_location: location_after_save
        else
          flash[:error] = result.error.to_s
        end
      end

      def increment_item
        existing_line_item = @shipment.line_items.select { |li| li.variant_id == params.dig(:shipment, :variant_id).to_i }

        if existing_line_item[0].quantity < params.dig(:shipment, :quantity).to_i
          increment_by = (params.dig(:shipment, :quantity).to_i - existing_line_item[0].quantity)

          params[:shipment][:quantity] = increment_by
          add_item
        else
          increment_by = (existing_line_item[0].quantity - params.dig(:shipment, :quantity).to_i)

          params[:shipment][:quantity] = increment_by
          remove_item
        end
      end

      SHIPMENT_STATES.each do |state|
        define_method state do
          result = change_state_service.call(shipment: @shipment, state: state)

          if result.success?
            redirect_back fallback_location: location_after_save
          else
            flash[:error] = result.error.to_s
          end
        end
      end

      def remove_item
        result = remove_item_service.call(
          shipment: @shipment,
          variant_id: params.dig(:shipment, :variant_id),
          quantity: params.dig(:shipment, :quantity)
        )

        if result.success?
          redirect_to location_after_save
        else
          flash[:error] = result.error.to_s
        end
      end

      private

      def location_after_save
        spree.edit_admin_order_url(@shipment.order)
      end

      def find_resource
        Spree::Shipment.find(params[:id])
      end

      def permitted_resource_params
        params.require(:shipment).permit(permitted_shipment_attributes + [:variant_id, :quantity, :order_id])
      end

      def create_service
        Spree::Dependencies.shipment_create_service.constantize
      end

      def update_service
        Spree::Dependencies.shipment_update_service.constantize
      end

      def change_state_service
        Spree::Dependencies.shipment_change_state_service.constantize
      end

      def add_item_service
        Spree::Dependencies.shipment_add_item_service.constantize
      end

      def remove_item_service
        Spree::Dependencies.shipment_remove_item_service.constantize
      end
    end
  end
end
