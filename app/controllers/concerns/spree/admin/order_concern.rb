module Spree
  module Admin
    module OrderConcern
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found
      end

      protected

      def collection
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

        per_page_limit = params[:per_page] || Spree::Backend::Config[:admin_orders_per_page]
        # lazy loading other models here (via includes) may result in an invalid query
        # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
        # see https://github.com/spree/spree/pull/3919
        @collection = @search.result(distinct: true)
        @pagy, @collection = pagy(@collection, items: per_page_limit)

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

      def sync_order
        @order.associate_user!(@user) if @user
        @order.update_with_updater!
        @order.create_proposed_shipments
        @order.next
        @order.reload
      end

      def load_order
        @order = current_store.orders.find_by!(number: params[:order_id] || params[:id])
        authorize! action, @order
        @order
      end

      def resource_not_found
        flash[:error] = flash_message_for(model_class.new, :not_found)
        redirect_to spree.admin_orders_path
      end
    end
  end
end
