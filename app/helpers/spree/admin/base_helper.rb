module Spree
  module Admin
    module BaseHelper
      include Pagy::Frontend

      FLATPICKR_SUPPORTED_LOCALES = %w[
        ar at az be bg bn bs cs cy da de eo es et fa fi fo fr ga gr he
        hi hr hu id is it ja ka km ko kz lv mk mn ms my nl no pa pl pt ro ru
        si sk sl sq sr sv th tr uk uz vn zh
      ].freeze

      def filters_in_use(filter)
        return if filter[1].blank?

        formatted_params = request.query_parameters[:q].except(filter[0].to_sym)
        params_hash = {q: formatted_params.to_hash}
        remove_filter_url = request.base_url + request.path + "?" + params_hash.to_query + "&commit=Filter"

        # Case through those query params that don't read human like and amend as needed.
        filter_value_text = case filter[0]
        when "deleted_at_null"
          " "
        else
          ": #{filter[1]} "
        end

        link_to remove_filter_url, class: "badge rgb-hsl-default", id: "removeFilter-#{filter[0]}", data: {turbo_cache: "false"} do
          (content_tag :span, I18n.t("spree.admin.filters.#{filter[0]}") + filter_value_text) + spree_admin_svg_tag("x-lg.svg", size: "16px*16px")
        end
      end

      def flash_alert(flash, turbo_frame_id = nil)
        return unless flash.present?

        if turbo_frame_id.nil?
          render "spree/admin/shared/toast", message: flash.first[1], kind: flash.first[0]
        elsif flash[:turbo_frame_request_id] == turbo_frame_id.to_s
          render "spree/admin/shared/toast", message: flash[:message], kind: flash[:kind]
        end
      end

      def field_container(model, method, options = {}, &block)
        css_classes = options[:class].to_a
        if css_classes.empty?
          css_classes << "form-group form-floating"
        end

        css_classes << "withError" if error_message_on(model, method).present?
        content_tag(
          :div, capture(&block),
          options.merge(class: css_classes.join(" "), id: "#{model}_#{method}_field")
        )
      end

      def checkbox_container(model, method, options = {}, &block)
        css_classes = options[:class].to_a
        css_classes << "form-check"
        css_classes << "withError" if error_message_on(model, method).present?
        content_tag(
          :div, capture(&block),
          options.merge(class: css_classes.join(" "), id: "#{model}_#{method}_field")
        )
      end

      def spree_admin_svg_tag(file_name, options = {})
        prefixed_file = "spree/backend/#{file_name}"

        inline_svg_tag(prefixed_file, options)
      end

      # Returns Humanized Dropdown Values From a Constant In the Model
      # Pass the model name as a string and then a hash containing the constant name
      # and the option to paramatize the return value.
      #
      # Example:
      #
      #   spree_humanize_dropdown_values('Spree::CmsPage', { const: 'TYPES' })
      #   spree_humanize_dropdown_values('Spree::Menu', { const: 'MENU_TYPES', paramterize_values: true })
      #
      def spree_humanize_dropdown_values(model_name, options = {})
        formatted_option_values = []

        const = options[:const] || nil
        paramterize_values = options[:paramterize_values] || false

        return unless const.present?

        model_name.constantize.const_get(const).map do |type|
          return_value = if paramterize_values
            type.parameterize(separator: "_")
          else
            type
          end

          formatted_option_values << [spree_humanize_type(type), return_value]
        end

        formatted_option_values
      end

      def spree_humanize_cms(cms_array)
        formatted_option_values = []

        cms_array.each do |section|
          formatted_option_values << [spree_humanize_type(section.name), section]
        end

        formatted_option_values
      end

      def spree_humanize_type(obj)
        last_word = obj.demodulize

        if last_word.starts_with?("Cms")
          last_word.slice(3, 100).gsub(/(?<=[a-z])(?=[A-Z])/, " ")
        else
          last_word.gsub(/(?<=[a-z])(?=[A-Z])/, " ")
        end
      end

      def error_message_on(object, method, _options = {})
        object = convert_to_model(object)
        obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

        if obj && obj.errors[method].present?
          errors = safe_join(obj.errors[method], "<br />".html_safe)
          content_tag(:span, errors, class: "formError")
        else
          ""
        end
      end

      def datepicker_field_value(date)
        unless date.blank?
          l(date, format: "%Y/%m/%d")
        end
      end

      def preference_field_tag(name, value, options)
        if options[:key] == :currency
          return select_tag(name, options_from_collection_for_select(supported_currencies_for_all_stores, :iso_code, :iso_code, value), data: {controller: "ts--search", form_state_target: "watch", input_disable_target: "disable"})
        end

        case options[:type]
        when :integer
          text_field_tag(name, value, preference_field_options(options))
        when :boolean
          hidden_field_tag(name, 0, id: "#{name}_hidden") +
            check_box_tag(name, 1, value, preference_field_options(options))
        when :string
          text_field_tag(name, value, preference_field_options(options))
        when :password
          password_field_tag(name, value, preference_field_options(options))
        when :text
          text_area_tag(name, value, preference_field_options(options))
        else
          text_field_tag(name, value, preference_field_options(options))
        end
      end

      def preference_field_for(form, field, options)
        case options[:type]
        when :integer
          form.text_field(field, preference_field_options(options))
        when :boolean
          form.check_box(field, preference_field_options(options))
        when :string
          form.text_field(field, preference_field_options(options))
        when :password
          form.password_field(field, preference_field_options(options))
        when :text
          form.text_area(field, preference_field_options(options))
        else
          form.text_field(field, preference_field_options(options))
        end
      end

      def preference_field_options(options)
        field_options = case options[:type]
        when :integer
          {
            size: 10,
            class: "input_integer form-control",
            placeholder: "-",
            data: {controller: "input-formatting", form_state_target: "watch", input_disable_target: "disable", input_formatting_options_value: {numeral: true, numeralDecimalScale: 0, numeralThousandsGroupStyle: "none"}}
          }
        when :decimal
          {
            size: 10,
            class: "input_decimal form-control",
            placeholder: "-",
            data: {controller: "input-formatting", form_state_target: "watch", input_disable_target: "disable", input_formatting_options_value: {numeral: true, numeralThousandsGroupStyle: "none"}}
          }
        when :boolean
          {
            class: "form-check-input",
            data: {form_state_target: "watch", input_disable_target: "disable"}
          }
        when :string
          {
            size: 10,
            class: "input_string form-control",
            placeholder: "-",
            data: {form_state_target: "watch", input_disable_target: "disable"}
          }
        when :password
          {
            size: 10,
            class: "password_string form-control",
            placeholder: "-",
            data: {form_state_target: "watch", input_disable_target: "disable"}
          }
        when :text
          {
            rows: 15,
            cols: 85,
            class: "text_string form-control",
            placeholder: "-",
            data: {form_state_target: "watch", input_disable_target: "disable"}
          }
        else
          {
            size: 10,
            class: "input_string form-control",
            placeholder: "-",
            data: {form_state_target: "watch", input_disable_target: "disable"}
          }
        end

        field_options.merge!(readonly: options[:readonly],
          disabled: options[:disabled],
          size: options[:size])
      end

      def preference_fields(object, form)
        return unless object.respond_to?(:preferences)

        fields = object.preferences.keys.map do |key|
          if object.has_preference?(key)
            case key
            when :currency
              content_tag(:div, (form.select "preferred_#{key}", currency_options(object.preferences[key]), {}, {autocomplete: false, class: "form-select", data: {controller: "ts--select", form_state_target: "watch", input_disable_target: "disable"}}) +
                form.label("preferred_#{key}", Spree.t(key)),
                class: "form-group form-floating", id: [object.class.to_s.parameterize, "preference", key].join("-"))
            else
              if object.preference_type(key).to_sym == :boolean
                content_tag(:div, preference_field_for(form, "preferred_#{key}", type: object.preference_type(key)) +
                  form.label("preferred_#{key}", Spree.t(key), class: "form-check-label"),
                  class: "form-group form-check", id: [object.class.to_s.parameterize, "preference", key].join("-"))
              else
                content_tag(:div, preference_field_for(form, "preferred_#{key}", type: object.preference_type(key)) + form.label("preferred_#{key}", Spree.t(key)),
                  class: "form-group form-floating", id: [object.class.to_s.parameterize, "preference", key].join("-"))
              end
            end
          end
        end
        safe_join(fields)
      end

      I18N_PLURAL_MANY_COUNT = 2.1
      def plural_resource_name(resource_class)
        resource_class.model_name.human(count: I18N_PLURAL_MANY_COUNT)
      end

      def order_time(time)
        return "" if time.blank?

        [I18n.l(time.to_date), time.strftime("%l:%M %p %Z").strip].join(" ")
      end

      def required_span_tag(required = true)
        if required
          content_tag(:span, " *", class: "required text-danger")
        else
          ""
        end
      end

      def external_page_preview_link(resource, options = {})
        resource_name = options[:name] || resource.class.name.demodulize

        link_to_with_icon(
          I18n.t("spree.admin.utilities.preview", name: resource_name),
          spree_storefront_resource_url(resource),
          class: "btn btn-secondary animate__animated animate__faster",
          icon: "eye.svg",
          id: "adminPreview#{resource_name}",
          target: :blank,
          data: {turbo: false,
                 stream_enter_class: "animate__fadeIn",
                 stream_exit_class: "animate__fadeOut"}
        )
      end

      def admin_logout_link
        if defined?(admin_logout_path)
          admin_logout_path
        elsif defined?(spree_logout_path)
          spree_logout_path
        end
      end

      def flatpickr_local_fallback
        stripped_locale = I18n.locale.to_s.split("-").first

        if I18n.locale.to_s == "zh-TW"
          "zh-tw"
        elsif FLATPICKR_SUPPORTED_LOCALES.include? stripped_locale
          stripped_locale.sub("-", "_")
        else
          "default"
        end
      end

      def product_wysiwyg_editor_enabled?
        Spree::Backend::Config[:product_wysiwyg_editor_enabled]
      end

      def taxon_wysiwyg_editor_enabled?
        Spree::Backend::Config[:taxon_wysiwyg_editor_enabled]
      end
    end
  end
end
