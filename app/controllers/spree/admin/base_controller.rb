module Spree
  module Admin
    class BaseController < ApplicationController
      include Pagy::Backend

      include Spree::Core::ControllerHelpers::Auth
      include Spree::Core::ControllerHelpers::Search
      include Spree::Core::ControllerHelpers::Store
      include Spree::Core::ControllerHelpers::StrongParameters
      include Spree::Core::ControllerHelpers::Locale
      include Spree::Core::ControllerHelpers::Currency

      respond_to :html

      helper "spree/base"
      helper "spree/admin/navigation"
      helper "spree/locale"
      helper "spree/currency"
      layout "spree/layouts/admin"

      before_action :authorize_admin, :load_stores, :load_main_menu_panel

      helper_method :admin_oauth_token, :stream_flash_alert

      protected

      default_form_builder(Spree::Dash::BootstrapBuilder)

      def action
        params[:action].to_sym
      end

      def authorize_admin
        record = if respond_to?(:model_class, true) && model_class
          model_class
        else
          controller_name.to_sym
        end
        authorize! :admin, record
        authorize! action, record
      end

      def redirect_unauthorized_access
        if try_spree_current_user
          dispatch_notice(Spree.t(:authorization_failure), :error)
          redirect_to spree.admin_forbidden_path
        else
          store_location
          if defined?(spree.admin_login_path)
            redirect_to spree.admin_login_path
          elsif respond_to?(:spree_login_path)
            redirect_to spree_login_path
          elsif spree.respond_to?(:root_path)
            redirect_to spree.root_path
          else
            redirect_to main_app.respond_to?(:root_path) ? main_app.root_path : "/"
          end
        end
      end

      def flash_message_for(object, event_sym, kind = :success)
        resource_desc = object.class.model_name.human
        resource_desc += " \"#{object.name}\"" if (object.persisted? || object.destroyed?) && object.respond_to?(:name) && object.name.present? && !object.is_a?(Spree::Order)

        dispatch_notice(Spree.t(event_sym, resource: resource_desc), kind)
      end

      def dispatch_notice(message, kind)
        turbo_frame_id = turbo_frame_request_id || :_top

        flash[:kind] = kind
        flash[:turbo_frame_request_id] = turbo_frame_id
        flash[:message] = message
      end

      def stream_flash_alert(message: I18n.t("spree.admin.no_message_set"), kind: :success)
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.append("FlashAlertsContainer", partial: "spree/admin/shared/toast", locals: {message: message, kind: kind})
          end
        end
      end

      def config_locale
        Spree::Backend::Config[:locale]
      end

      def stores_scope
        Spree::Store.accessible_by(current_ability, :show)
      end

      def load_stores
        @stores = stores_scope.order(default: :desc)
      end

      def load_main_menu_panel
        @menu_panel_kind = "main"
      end

      def can_not_transition_without_customer_info
        unless @order.billing_address.present?
          dispatch_notice(Spree.t(:fill_in_customer_info), :notice)
          redirect_to spree.edit_admin_order_url(@order)
        end
      end

      def admin_oauth_application
        @admin_oauth_application ||= Spree::OauthApplication.find_or_create_by!(name: "Admin Panel", scopes: "admin", redirect_uri: "")
      end

      # FIXME: auto-expire this token
      def admin_oauth_token
        user = try_spree_current_user
        return unless user

        @admin_oauth_token ||= begin
          Spree::OauthAccessToken.active_for(user).where(application_id: admin_oauth_application.id).last ||
            Spree::OauthAccessToken.create!(
              resource_owner: user,
              application_id: admin_oauth_application.id,
              scopes: admin_oauth_application.scopes
            )
        end.token
      end
    end
  end
end
