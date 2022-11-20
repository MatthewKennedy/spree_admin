module Spree
  module Admin
    class PromotionsController < ResourceController
      before_action :load_data, except: :clone

      helper "spree/admin/promotion_rules"

      def clone
        promotion = current_store.promotions.find(params[:id])
        duplicator = Spree::PromotionHandler::PromotionDuplicator.new(promotion)

        @new_promo = duplicator.duplicate

        if @new_promo.errors.empty?
          dispatch_notice(I18n.t("spree.admin.promotion_cloned"), :success)
          redirect_to spree.edit_admin_promotion_url(@new_promo)
        else
          dispatch_notice(I18n.t("spree.admin.promotion_not_cloned", error: @new_promo.errors.full_messages.to_sentence), :error)
          redirect_to spree.admin_promotions_url(@new_promo)
        end
      end

      protected

      def location_after_save
        spree.edit_admin_promotion_url(@promotion)
      end

      def load_data
        @actions = Rails.application.config.spree.promotions.actions

        @calculators = Rails.application.config.spree.calculators.promotion_actions_create_adjustments
        @promotion_categories = Spree::PromotionCategory.order(:name)
        @product_options = []
      end

      def collection
        return @collection if defined?(@collection)

        per_page_limit = params[:per_page] || Spree::Backend::Config[:admin_promotions_per_page]

        params[:q] ||= HashWithIndifferentAccess.new
        params[:q][:s] ||= "id desc"

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result(distinct: true).includes(promotion_includes)

        @pagy, @collection = pagy(@collection, items: per_page_limit)
        @collection
      end

      def promotion_includes
        [:promotion_actions]
      end
    end
  end
end
