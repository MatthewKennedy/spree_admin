module Spree
  module Admin
    class AddressesController < ResourceController
      before_action :find_user

      def new
        @address = Spree::Address.new(country: current_store.default_country, user_id: params[:user_id])
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

      def find_user
        if params[:address]
          @user ||= Spree::User.find(params[:address][:user_id]) if params[:address][:user_id]
        end
      end

      def update_country_params
        params.fetch(:address, {}).permit(permitted_address_attributes)
      end

      def location_after_save
        spree.addresses_admin_user_path(@address.user)
      end
    end
  end
end
