module Spree
  module Admin
    class UsersController < ResourceController
      rescue_from Spree::Core::DestroyWithOrdersError, with: :user_destroy_with_orders_error
      after_action :sign_in_if_change_own_password, only: :update
      before_action :other_addresses, only: [:addresses, :update_address]

      def index
        render "list" if params[:page]
      end

      def show
        redirect_to spree.edit_admin_user_path(@user)
      end

      def create
        @user = Spree.user_class.new(user_params)
        if @user.save
          flash[:success] = flash_message_for(@user, :successfully_created)
          redirect_to spree.edit_admin_user_path(@user)
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end

        super
      end

      def addresses
      end

      def customer_details
      end

      def update_address
        if @user.update(permitted_resource_params)
        else
          stream_flash_alert(message: I18n.t("spree.admin.products.errors.status_could_not_be_updated"), kind: :error)
        end
      end

      def orders
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= "1"

        if params[:q][:number_i_cont].present?
          params[:q].delete(:completed_at_not_null)
        end

        @search = current_store.orders.reverse_chronological.ransack(params[:q].merge(user_id_eq: @user.id))

        @orders = @search.result
        @pagy, @orders = pagy(@orders, items: 5)

        respond_with(@orders) do |format|
          format.html
        end
      end

      def items
        params[:q] ||= {}
        @search = current_store.orders.includes(
          line_items: {
            variant: [:product, {option_values: :option_type}]
          }
        ).ransack(params[:q].merge(user_id_eq: @user.id))
        @orders = @search.result.page(params[:page])
      end

      protected

      def model_class
        Spree.user_class
      end

      def collection
        return @collection if @collection.present?

        @collection = super

        per_page_limit = params[:per_page] || Spree::Backend::Config[:admin_users_per_page]

        @search = @collection.ransack(params[:q])
        @collection = @search.result
        @pagy, @collection = pagy(@collection, items: per_page_limit)

        @collection
      end

      def location_after_save
        spree.edit_admin_user_path(@user)
      end

      private

      def user_params
        params.fetch(:user, {}).permit(permitted_user_attributes |
                                     [:use_billing,
                                       spree_role_ids: [],
                                       ship_address_attributes: permitted_address_attributes,
                                       bill_address_attributes: permitted_address_attributes])
      end

      # handling raise from Spree::Admin::ResourceController#destroy
      def user_destroy_with_orders_error
        invoke_callbacks(:destroy, :fails)
        render status: :forbidden, plain: Spree.t(:error_user_destroy_with_orders)
      end

      def sign_in_if_change_own_password
        if try_spree_current_user == @user && @user.password.present?
          sign_in(@user, event: :authentication, bypass: true)
        end
      end

      def other_addresses
        @other_addresses ||= @user.addresses.where.not(id: [@user.bill_address.try(:id), @user.ship_address.try(:id)])
      end
    end
  end
end
