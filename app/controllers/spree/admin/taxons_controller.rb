module Spree
  module Admin
    class TaxonsController < ResourceController
      belongs_to "spree/taxonomy"

      before_action :set_permalink_part, only: [:edit]

      def index
      end

      def products_panel
        if params[:taxon_id].blank?
          head :no_content
        else
          @taxon = Taxon.find(params[:taxon_id])
        end
      end

      def update
        successful = @taxon.transaction do
          parent_id = params[:taxon][:parent_id]
          set_position
          set_parent(parent_id)

          @taxon.save!

          # regenerate permalink
          regenerate_permalink if parent_id

          set_permalink_params

          # check if we need to rename child taxons if parent name or permalink changes
          @update_children = true if params[:taxon][:name] != @taxon.name || params[:taxon][:permalink] != @taxon.permalink

          @taxon.create_icon(attachment: taxon_params[:icon]) if taxon_params[:icon]
          @taxon.update(taxon_params.except(:icon))
        end
        if successful
          flash[:success] = flash_message_for(@taxon, :successfully_updated)

          # rename child taxons
          rename_child_taxons if @update_children

          respond_with(@taxon) do |format|
            format.html { redirect_to spree.edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id) }
          end
        else
          respond_with(@taxon) do |format|
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def remove_icon
        if @taxon.icon.destroy
          flash[:success] = I18n.t("spree.dash.notice_messages.icon_removed")
          redirect_to spree.edit_admin_taxonomy_taxon_url(@taxonomy.id, @taxon.id)
        else
          flash[:error] = I18n.t("spree.dash.errors.messages.cannot_remove_icon")
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def successful_reposition_actions
        reload_taxon_and_set_new_permalink(@taxon)
        update_permalinks_on_child_taxons

        respond_to do |format|
          format.turbo_stream { render "spree/admin/taxonomies/reposition" }
        end
      end

      def reload_taxon_and_set_new_permalink(taxon)
        taxon.reload
        taxon.set_permalink
        taxon.save!
      end

      def update_permalinks_on_child_taxons
        @taxon.descendants.each do |taxon|
          reload_taxon_and_set_new_permalink(taxon)
        end
      end

      def location_after_save
        spree.edit_admin_taxonomy_taxon_path(@taxonomy.id, @taxon.id)
      end

      def parent_data
        if action_name == "index"
          nil
        else
          super
        end
      end

      def set_permalink_part
        @permalink_part = @taxon.permalink.split("/").last
        @parent_permalink = @taxon.permalink.split("/")[0...-1].join("/")
        @parent_permalink += "/" unless @parent_permalink.blank?
      end

      def taxon_params
        params.require(:taxon).permit(permitted_taxon_attributes)
      end

      def set_position
        new_position = params[:taxon][:position]
        @taxon.child_index = new_position.to_i if new_position
      end

      def set_parent(parent_id)
        @taxon.parent = current_store.taxons.find(parent_id) if parent_id
      end

      def set_permalink_params
        set_permalink_part

        if params[:taxon][:permalink_part].present?
          params[:taxon][:permalink] = @parent_permalink + params[:taxon][:permalink_part]
        end
      end

      def rename_child_taxons
        @taxon.descendants.each do |taxon|
          reload_taxon_and_set_permalink(taxon)
        end
      end

      def regenerate_permalink
        reload_taxon_and_set_permalink(@taxon)
        @update_children = true
      end

      def reload_taxon_and_set_permalink(taxon)
        taxon.reload
        taxon.set_permalink
        taxon.save!
      end

      def scope
        current_store.taxons
      end
    end
  end
end
