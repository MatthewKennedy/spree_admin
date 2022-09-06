module Spree
  module Admin
    class AddressesController < ResourceController
      include Spree::Admin::OrderConcern

      before_action :find_resources
      create.after :persist_order

      def new
        @address = Spree::Address.new(country: current_store.default_country, user_id: params[:address][:user_id])
      end

      def update_country
        @address = Spree::Address.new(update_country_params)

        # Empty out the zipcode and State on country change.
        @address.zipcode = nil
        @address.state = nil

        respond_with(@address) do |format|
          format.turbo_stream
        end
      end

      private

      def find_resources
        if params[:order_id]
          load_order
        else
          @user ||= Spree::User.find(params[:address][:user_id]) if params[:address][:user_id].present?
          @user ||= @address.user
        end
      end

      def persist_order
        if params[:address_kind].present?
          if params[:address_kind] == "bill_address"
            if @order.update(bill_address: @address)
              sync_order
            end
          elsif params[:address_kind] == "ship_address"
            if @order.update(ship_address: @address)
              sync_order
            end
          end
        end
      end

      def update_country_params
        params.fetch(:address, {}).permit(permitted_address_attributes)
      end

      def location_after_save
        if params[:address][:user_id].present?
          spree.addresses_admin_user_path(@address.user)
        elsif params[:order_id].present?
          spree.edit_admin_order_url(@order)
        end
      end
    end
  end
end
