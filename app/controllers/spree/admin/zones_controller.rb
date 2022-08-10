module Spree
  module Admin
    class ZonesController < ResourceController
      before_action :load_data, except: :index

      def new
        @zone.zone_members.build
      end

      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "name asc"
        @search = super.ransack(params[:q])
        @zones = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        @countries = Country.order(:name)
        @states = State.order(:name)
        @zones = Zone.order(:name)
      end

      def location_after_save
        spree.edit_admin_zone_path(@zone)
      end

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end
    end
  end
end
