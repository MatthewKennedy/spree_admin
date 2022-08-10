module Spree
  module Admin
    class CmsPagesController < ResourceController
      def update_visibility
        if @object.update(visible: permitted_resource_params[:visible])
          respond_to do |format|
            format.turbo_stream
          end
        else
          stream_flash_alert(message: I18n.t("spree.dash.cms_pages.errors.could_not_update_page_visibility"), kind: :error)
        end
      end

      private

      def scope
        current_store.cms_pages
      end

      def find_resource
        scope.find(params[:id])
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = scope

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def location_after_save
        spree.edit_admin_cms_page_path(@cms_page)
      end
    end
  end
end
