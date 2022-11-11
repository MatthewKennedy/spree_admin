class Spree::Admin::PromotionRulesController < Spree::Admin::BaseController
  helper "spree/admin/promotion_rules"

  before_action :load_promotion, only: [:create, :destroy, :product_options]
  before_action :validate_promotion_rule_type, only: :create

  def create
    @promotion_rule = @promotion_rule_type.new(promotion_rule_params)
    @promotion_rule.promotion = @promotion
    if @promotion_rule.save
      flash[:success] = Spree.t(:successfully_created, resource: Spree.t(:promotion_rule))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
    end
  end

  def destroy
    @promotion_rule = @promotion.promotion_rules.find(params[:id])
    if @promotion_rule.destroy
      flash[:success] = Spree.t(:successfully_removed, resource: Spree.t(:promotion_rule))
    end
    respond_to do |format|
      format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
    end
  end

  def product_options
    @product ||= Spree::Product.find(params[:product_id])
    @product_options ||= @product.all_option_values
    @promotion_rule ||= @promotion.promotion_rules.find(params[:promotion_rule_id])
  end

  private

  def load_promotion
    @promotion = current_store.promotions.find(params[:promotion_id])
  end

  def validate_promotion_rule_type
    requested_type = params[:promotion_rule].delete(:type)
    promotion_rule_types = Rails.application.config.spree.promotions.rules
    @promotion_rule_type = promotion_rule_types.detect do |klass|
      klass.name == requested_type
    end
    unless @promotion_rule_type
      flash[:error] = Spree.t(:invalid_promotion_rule)
      respond_to do |format|
        format.html { redirect_to spree.edit_admin_promotion_path(@promotion) }
      end
    end
  end

  def promotion_rule_params
    params[:promotion_rule].permit!
  end
end
