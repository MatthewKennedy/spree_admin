module Spree
  module Dash
    class BootstrapBuilder < ActionView::Helpers::FormBuilder
      # include ActionView::Helpers::TagHelper
      # include ActionView::Context

      def label(method, text = nil, options = {})
        super(method, text, options.reverse_merge(class: "form-label"))
      end

      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        super(method, options.reverse_merge(class: "form-check-input", data: {form_state_target: "watch"}), checked_value, unchecked_value)
      end

      def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        super(method, collection, value_method, text_method, options, html_options.reverse_merge(class: "form-select", data: {controller: "ts--select", form_state_target: "watch"}))
      end

      def number_field(method, options = {})
        super(method, options.reverse_merge(placeholder: method.to_s.capitalize, class: "form-control", data: { controller: "input--format-integer", form_state_target: "watch"}))
      end

      def radio_button(method, tag_value, options = {})
        super(method, tag_value, options.reverse_merge(class: "form-check-input", data: {form_state_target: "watch"}))
      end

      def text_field(method, options = {})
        super(method, options.reverse_merge(placeholder: method.to_s.capitalize, class: "form-control", data: {form_state_target: "watch"}, autocomplete: false))
      end

      def text_area(method, options = {})
        super(method, options.reverse_merge(placeholder: method.to_s.capitalize, class: "form-control", data: {form_state_target: "watch"}))
      end

      def select(object_name, method_name, template_object, options = {}, &block)
        super(object_name, method_name, template_object, options.reverse_merge(class: "form-select", data: {controller: "ts--select", form_state_target: "watch"}, &block))
      end

      def file_field(method, options = {})
        super(method, options.reverse_merge(class: "form-control", data: {form_state_target: "watch"}))
      end
    end
  end
end
