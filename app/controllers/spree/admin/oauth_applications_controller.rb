module Spree
  module Admin
    class OauthApplicationsController < ResourceController
      before_action :set_default_scopes, only: [:new, :edit]

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def create_turbo_stream_enabled?
        true
      end

      def set_default_scopes
        @object.scopes = "admin" if @object.scopes.blank?
      end
    end
  end
end
