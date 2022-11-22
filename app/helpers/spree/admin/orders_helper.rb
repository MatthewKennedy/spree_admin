module Spree
  module Admin
    module OrdersHelper
      # Renders all the extension partials that may have been specified in the extensions
      def event_links(order, events)
        links = []
        events.each do |event|
          next unless order.send("can_#{event}?")

          label = Spree.t(event, scope: "admin.order.events", default: Spree.t(event))
          links << link_to_with_icon(label.capitalize, [event.to_sym, :admin, order], icon: event.to_s + ".svg", data: {turbo_method: :put, turbo_confirm: Spree.t(:order_sure_want_to, event: label)}, class: "btn btn-secondary")
        end
        safe_join(links, "".html_safe)
      end

      def line_item_shipment_price(line_item, quantity)
        Spree::Money.new(line_item.price * quantity, currency: line_item.currency)
      end

      def order_risk_state_badge(order)
        if order.considered_risky
          badge_style = "rgb-hsl-danger"
          badge_text = I18n.t("spree.admin.risky")
        else
          badge_style = if order.complete?
            "rgb-hsl-muted"
          else
            "rgb-hsl-success"
          end

          badge_text = I18n.t("spree.admin.safe")
        end

        content_tag :span, badge_text, class: "badge rounded-pill #{badge_style}"
      end

      def order_payment_state_badge(order)
        badge_style = if order.payment_state == "paid"
          order.complete? ? "rgb-hsl-muted" : "rgb-hsl-success"
        else
          "rgb-hsl-secondary"
        end

        content_tag :span, I18n.t("spree.admin.payment_states.#{order.payment_state}"), class: "badge rounded-pill #{badge_style}"
      end

      def order_shipment_badge(order)
        badge_style = if order.shipment_state == "shipped"
          order.complete? ? "rgb-hsl-muted" : "rgb-hsl-success"
        else
          "rgb-hsl-secondary"
        end

        content_tag :span, I18n.t("spree.admin.shipment_states.#{order.shipment_state}"), class: "badge rounded-pill #{badge_style}"
      end

      def avs_response_code
        {
          "A" => I18n.t("spree.admin.avs_responses.street_address_matches_but_5-digit_and_9_digit_postal_code_do_not_match"),
          "B" => I18n.t("spree.admin.avs_responses.street_address_matches_but_postal_code_not_verified"),
          # TODO MSK translate these
          "C" => "Street address and postal code do not match.",
          "D" => "Street address and postal code match. ",
          "E" => "AVS data is invalid or AVS is not allowed for this card type.",
          "F" => "Card member's name does not match, but billing postal code matches.",
          "G" => "Non-U.S. issuing bank does not support AVS.",
          "H" => "Card member's name does not match. Street address and postal code match.",
          "I" => "Address not verified.",
          "J" => "Card member's name, billing address, and postal code match.",
          "K" => "Card member's name matches but billing address and billing postal code do not match.",
          "L" => "Card member's name and billing postal code match, but billing address does not match.",
          "M" => "Street address and postal code match. ",
          "N" => "Street address and postal code do not match.",
          "O" => "Card member's name and billing address match, but billing postal code does not match.",
          "P" => "Postal code matches, but street address not verified.",
          "Q" => "Card member's name, billing address, and postal code match.",
          "R" => "System unavailable.",
          "S" => "Bank does not support AVS.",
          "T" => "Card member's name does not match, but street address matches.",
          "U" => "Address information unavailable. Returned if the U.S. bank does not support non-U.S. AVS or if the AVS in a U.S. bank is not functioning properly.",
          "V" => "Card member's name, billing address, and billing postal code match.",
          "W" => "Street address does not match, but 9-digit postal code matches.",
          "X" => "Street address and 9-digit postal code match.",
          "Y" => "Street address and 5-digit postal code match.",
          "Z" => "Street address does not match, but 5-digit postal code matches."
        }
      end

      def cvv_response_code
        {
          "M" => "CVV2 Match",
          "N" => "CVV2 No Match",
          "P" => "Not Processed",
          "S" => "Issuer indicates that CVV2 data should be present on the card, but the merchant has indicated data is not present on the card",
          "U" => "Issuer has not certified for CVV2 or Issuer has not provided Visa with the CVV2 encryption keys",
          "" => "Transaction failed because wrong CVV2 number was entered or no CVV2 number was entered"
        }
      end
    end
  end
end
