module Spree
  module Admin
    class StoresController < Spree::Admin::BaseController
      before_action :load_store, only: [:new, :edit, :update]
      before_action :set_default_currency, only: :new
      before_action :set_default_locale, only: :new
      before_action :normalize_supported_currencies, only: [:create, :update]
      before_action :normalize_supported_locales, only: [:create, :update]
      before_action :set_default_country_id, only: :new
      before_action :load_all_countries, only: [:new, :edit, :update, :create]
      before_action :load_all_zones, only: [:new, :edit, :update, :create]

      def create
        @store = stores_scope.new(permitted_store_params)

        if @store.save
          flash_message_for(@store, :successfully_created)
          redirect_to spree.admin_url(domain: @store.url), allow_other_host: true
        else
          dispatch_notice("#{I18n.t("spree.admin.store_errors.unable_to_create")}: #{@store.errors.full_messages.join(", ")}", :error)
          render :new, status: :unprocessable_entity
        end
      end

      def switcher
        # DO NOT REMOVE!!
        # This is used to launch the Store Switcher Modal.
      end

      def update
        @store.assign_attributes(permitted_store_params)

        if @store.save
          flash_message_for(@store, :successfully_updated)
        else
          dispatch_notice("#{I18n.t("spree.admin.store_errors.unable_to_update")}: #{@store.errors.full_messages.join(", ")}", :error)
        end

        redirect_to spree.edit_admin_store_path(@store)
      end

      def destroy
        @store = stores_scope.find(params[:id])

        if @store.destroy
          flash_message_for(@store, :successfully_removed)
          redirect_to spree.admin_url(domain: Spree::Store.default.url), allow_other_host: true
        else
          render plain: "#{I18n.t("spree.admin.store_errors.unable_to_delete")}: #{@store.errors.full_messages.join(", ")}", status: :unprocessable_entity
        end
      end

      protected

      def permitted_store_params
        params.require(:store).permit(permitted_store_attributes)
      end

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def load_store
        @store = stores_scope.find_by(id: params[:id]) || stores_scope.new
      end

      def load_all_countries
        @countries = Spree::Country.pluck(:name, :id)
      end

      def load_all_zones
        @zones = Spree::Zone.pluck(:name, :id)
      end

      def set_default_currency
        @store.default_currency = Spree::Store.default.default_currency
      end

      def set_default_locale
        @store.default_locale = I18n.locale
      end

      def normalize_supported_currencies
        if params[:store][:supported_currencies]&.is_a?(Array)
          params[:store][:supported_currencies] = params[:store][:supported_currencies].compact.uniq.reject(&:blank?).join(",")
        end
      end

      def normalize_supported_locales
        if params[:store][:supported_locales]&.is_a?(Array)
          params[:store][:supported_locales] = params[:store][:supported_locales].compact.uniq.reject(&:blank?).join(",")
        end
      end

      def set_default_country_id
        @store.default_country_id ||= Spree::Store.default.default_country_id || Spree::Country.find_by(iso: "US")&.id
      end
    end
  end
end
