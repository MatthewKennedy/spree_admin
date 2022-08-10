module Spree
  module Admin
    class DigitalsController < ResourceController
      belongs_to "spree/product", find_by: :slug

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params

        if @object.valid?
          super
        else
          invoke_callbacks(:create, :fails)
          flash[:error] = @object.errors.full_messages.join(", ")
          respond_with(@object) do |format|
            format.html { render action: :index, status: :unprocessable_entity }
          end
        end
      end

      private

      def location_after_save
        if @object.variant.is_master
          spree.edit_admin_product_path(@product)
        else
          spree.edit_admin_product_variant_path(@product, @object.variant)
        end
      end

      def permitted_resource_params
        params.require(:digital).permit(permitted_digital_attributes)
      end

      def permitted_digital_attributes
        %i[variant_id attachment attachment_file_name attachment_content_type]
      end
    end
  end
end
