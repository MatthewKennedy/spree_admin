module Spree
  module Admin
    class ReimbursementTypesController < ResourceController
      def update
        invoke_callbacks(:update, :before)
        if @object.update(permitted_resource_params_for_update)
          invoke_callbacks(:update, :after)
          respond_with(@object) do |format|
            format.html do
              flash_message_for(@object, :successfully_updated)
              redirect_to location_after_save
            end
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :edit }
          end
        end
      end

      private

      def load_main_menu_panel
        @menu_panel_kind = "settings"
      end

      def permitted_resource_params_for_update
        params_hash = @object.type.underscore.remove("spree/").tr("/", "_")
        params.require(params_hash.to_s).permit(:name, :active, :mutable)
      end
    end
  end
end
