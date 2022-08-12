module Spree
  module Admin
    class OrdersController < Spree::Admin::BaseController
      include Spree::Admin::OrderConcern

      before_action :initialize_order_events
      before_action :load_order, only: %i[reset_digitals edit update cancel resume approve resend open_adjustments close_adjustments]
      before_action :load_user, only: %i[update]

      def index
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= "1" if Spree::Backend::Config[:show_only_complete_orders_by_default]
        @show_only_completed = params[:q][:completed_at_not_null] == "1"
        params[:q][:s] ||= @show_only_completed ? "completed_at desc" : "created_at desc"
        params[:q][:completed_at_not_null] = "" unless @show_only_completed

        # As date params are deleted if @show_only_completed, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

        if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
            Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
          rescue
            ""
          end
        end

        if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
            Time.zone.parse(params[:q][:created_at_lt]).end_of_day
          rescue
            ""
          end
        end

        if @show_only_completed
          params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
          params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
        end

        @search = scope.preload(:user).accessible_by(current_ability, :index).ransack(params[:q])

        # lazy loading other models here (via includes) may result in an invalid query
        # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
        # see https://github.com/spree/spree/pull/3919
        @orders = @search.result(distinct: true)
          .page(params[:page])
          .per(params[:per_page] || Spree::Backend::Config[:admin_orders_per_page])

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

      def new
        @order = scope.create(order_params)

        redirect_to spree.edit_admin_order_url(@order)
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

      private

      def sync_order
        @order.associate_user!(@user)
        @order.update_with_updater!
        @order.create_proposed_shipments
        @order.next
        @order.reload
      end

      def load_user
        return if params[:order][:user_id].blank?
        @user = Spree.user_class.find(params[:order][:user_id])
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
