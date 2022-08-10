module Spree
  module Admin
    class PaymentMethodsController < ResourceController
      before_action :load_data
      before_action :validate_payment_method_provider, only: :create

      def create
        @payment_method = params[:payment_method].delete(:type).constantize.new(payment_method_params)
        @object = @payment_method
        set_current_store

        super
      end

      def update
        attributes = payment_method_params.merge(preferences_params)
        attributes.each do |k, _v|
          attributes.delete(k) if k.include?("password") && attributes[k].blank?
        end

        super
      end

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def scope
        current_store.payment_methods.accessible_by(current_ability, :index)
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = super.order(position: :asc)

        @collection = scope.order(position: :asc)

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @providers = Gateway.providers.sort_by(&:name)
      end

      def validate_payment_method_provider
        valid_payment_methods = Rails.application.config.spree.payment_methods.map(&:to_s)
        unless valid_payment_methods.include?(params[:payment_method][:type])
          flash[:error] = Spree.t(:invalid_payment_provider)
          redirect_to spree.new_admin_payment_method_path
        end
      end

      def payment_method_params
        params.require(:payment_method).permit!
      end

      def preferences_params
        key = ActiveModel::Naming.param_key(@payment_method)
        return {} unless params.key? key

        params.require(key).permit!
      end

      def location_after_save
        spree.edit_admin_payment_method_path(@payment_method)
      end
    end
  end
end
