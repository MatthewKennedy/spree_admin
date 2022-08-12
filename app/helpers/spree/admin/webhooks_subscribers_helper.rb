module Spree
  module Admin
    module WebhooksSubscribersHelper
      def event_checkbox_for(resource_name, form)
        content_tag :div, class: "col-12 col-sm-6 col-md-4 col-lg-4 form-group" do
          content_tag :div, class: "form-check" do
            (form.check_box resource_name, event_checkbox_opts(resource_name), true, nil) + " " +
              form.label(resource_name, I18n.t("spree.admin.webhooks.subscribers.#{resource_name.to_s.pluralize}"), class: "form-check-label")
          end
        end
      end

      def subscribe_to_all_events?
        @webhooks_subscriber.new_record? || @webhooks_subscriber.subscriptions == ["*"]
      end

      private

      def event_checkbox_opts(resource_name)
        {
          class: "form-check-input",
          checked: subscribed_to_resource?(resource_name)
        }
      end

      def subscribed_to_resource?(resource_name)
        @webhooks_subscriber.subscriptions&.any? { |event| event.include? "#{resource_name}." }
      end
    end
  end
end
