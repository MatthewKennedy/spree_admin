module Spree
  module Admin
    class OrdersController < Spree::Admin::BaseController
      include Spree::Admin::OrderConcern

      before_action :load_order, except: %i[index new]
      before_action :initialize_order_events, :set_customer_status
      before_action :load_user, only: %i[update]

      def filter
        collection
      end

      def index
        collection
      end

      def new
        @order = scope.create(order_params)
        @user = Spree.user_class.find(params[:user_id]) if params[:user_id].present?

        if @order.save
          sync_order

          redirect_to spree.edit_admin_order_url(@order)
        elsif @order.line_items.empty?
          @order.errors.add(:line_items, I18n.t("spree.admin.errors.messages.blank"))
        end
      end

      def edit
        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_BACK_END) unless @order.completed?
      end

      def update
        if @order.update(permitted_resource_params)
          sync_order

          redirect_back fallback_location: spree.edit_admin_order_url(@order)
        elsif @order.line_items.empty?
          @order.errors.add(:line_items, I18n.t("spree.admin.errors.messages.blank"))
        end
      end

      def cancel
        @order.canceled_by(try_spree_current_user)
        flash[:success] = Spree.t(:order_canceled)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resume
        @order.resume!
        flash[:success] = Spree.t(:order_resumed)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def approve
        @order.approved_by(try_spree_current_user)
        flash[:success] = Spree.t(:order_approved)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resend
        @order.deliver_order_confirmation_email
        flash[:success] = Spree.t(:order_email_resent)

        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def reset_digitals
        @order.digital_links.each(&:reset!)
        flash[:notice] = I18n.t("spree.admin.digitals.downloads_reset")

        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def open_adjustments
        adjustments = @order.all_adjustments.finalized
        adjustments.update_all(state: "open")
        flash[:success] = Spree.t(:all_adjustments_opened)

        redirect_back fallback_location: spree.admin_order_adjustments_url(@order)
      end

      def close_adjustments
        adjustments = @order.all_adjustments.not_finalized
        adjustments.update_all(state: "closed")
        flash[:success] = Spree.t(:all_adjustments_closed)

        redirect_back fallback_location: spree.admin_order_adjustments_url(@order)
      end

      def new_bill_address
        @address = @order.build_bill_address(country: current_store.default_country)
      end

      def new_ship_address
        @address = @order.build_ship_address(country: current_store.default_country)
      end

      def new_customer
        @customer_status = "new"
        render :edit
      end

      def existing_customer
        @customer_status = "existing"
        render :edit
      end

      def reset_customer_details
        @order.update(email: nil, billing_address: nil, shipping_address: nil, user: nil)
        redirect_back fallback_location: spree.edit_admin_order_path(@order)
      end

      private

      def set_customer_status
        if @order
          @customer_status = "existing" if @order.user.present?
        end

        @customer_status ||= "new"
      end

      def load_user
        @user = Spree.user_class.find(params[:order][:user_id]) if params[:order][:user_id].present?
      end

      def scope
        current_store.orders.accessible_by(current_ability, :index)
      end

      def model_class
        Spree::Order
      end

      def permitted_resource_params
        params.require(:order).permit(permitted_order_attributes)
      end

      def order_params
        params.permit(:created_by_id, :user_id, :store_id, :channel)
          .with_defaults(created_by_id: try_spree_current_user.try(:id))
      end

      # Used for extensions which need to provide their own custom event links on the order details view.
      def initialize_order_events
        @order_events = %w[approve cancel resume]
      end
    end
  end
end
