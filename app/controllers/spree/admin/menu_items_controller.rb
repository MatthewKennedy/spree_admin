module Spree
  module Admin
    class MenuItemsController < ResourceController
      belongs_to "spree/menu"

      before_action :load_data

      def collection_url
        spree.edit_admin_menu_path(@menu)
      end

      def location_after_save
        spree.edit_admin_menu_menu_item_path(@menu, @menu_item)
      end

      def remove_icon
        if @menu_item.icon&.destroy
          dispatch_notice(I18n.t("spree.admin.notice_messages.icon_removed"), :success)
          redirect_to spree.edit_admin_menu_menu_item_path(@menu, @menu_item)
        else
          dispatch_notice(I18n.t("spree.admin.errors.messages.cannot_remove_icon"), :error)
          render :edit
        end
      end

      private

      def load_data
        @menu_item_types = Spree::MenuItem::ITEM_TYPE
      end

      def scope
        current_store.menu_items
      end
    end
  end
end
