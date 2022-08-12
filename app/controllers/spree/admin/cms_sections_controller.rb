module Spree
  module Admin
    class CmsSectionsController < ResourceController
      belongs_to "spree/cms_page"

      def update_position
        if @object.update(position: permitted_resource_params[:position])
          respond_to do |format|
            format.turbo_stream
          end
        else
          stream_flash_alert(message: I18n.t("spree.admin.cms_sections.errors.position_could_not_be_updated"), kind: :error)
        end
      end

      private

      def collection_url
        spree.edit_admin_cms_page_path(@cms_page)
      end

      def location_after_save
        spree.edit_admin_cms_page_cms_section_path(@cms_page, @cms_section)
      end
    end
  end
end
