module Spree
  module Admin
    module ProductsHelper
      # will return a human readable string
      def available_status(product)
        return I18n.t("spree.dash.products.archived") if product.status == "archived"
        return I18n.t("spree.dash.products.deleted") if product.deleted?

        if product.available?
          I18n.t("spree.dash.products.active")
        else
          I18n.t("spree.dash.products.draft")
        end
      end
    end
  end
end
