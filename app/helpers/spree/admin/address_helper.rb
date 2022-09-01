module Spree
  module Admin
    module AddressHelper
      def state_label(country)
        case country.iso3
        when "ARE"
          I18n.t("spree.admin.address.emirate")
        when "AUS"
          I18n.t("spree.admin.address.state_territory")
        else
          I18n.t("spree.admin.address.state")
        end
      end

      def zipcode_label(country)
        case country.iso3
        when "GBR"
          I18n.t("spree.admin.address.post_code")
        when "CAN"
          I18n.t("spree.admin.address.post_code")
        when "AUS"
          I18n.t("spree.admin.address.post_code")
        else
          I18n.t("spree.admin.address.zipcode")
        end
      end
    end
  end
end
