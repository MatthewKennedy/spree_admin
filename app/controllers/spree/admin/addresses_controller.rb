module Spree
  module Admin
    class AddressesController < ResourceController
      def new
        @user = User.find(params[:user_id]) if params[:user_id]

        @address = Spree::Address.new(country: current_store.default_country, user_id: params[:user_id])
      end

      private

      def location_after_save
        spree.edit_admin_user_path(@address.user)
      end
    end
  end
end
