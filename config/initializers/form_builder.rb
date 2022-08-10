#
# Allow some application_helper methods to be used in the scoped form_with model: manner
#
class ActionView::Helpers::FormBuilder
  def field_container(method, options = {}, &block)
    @template.field_container(@object_name, method, options, &block)
  end

  def checkbox_container(method, options = {}, &block)
    @template.checkbox_container(@object_name, method, options, &block)
  end

  def error_message_on(method, options = {})
    @template.error_message_on(@object_name, method, objectify_options(options))
  end
end

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html = ""

  form_fields = [
    "textarea",
    "input",
    "select"
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(", ")

  elements.each do |e|
    if e.node_name.eql? "label"
      html = e.to_s.html_safe
    elsif form_fields.include? e.node_name
      e["class"] += " is-invalid"
      html = if instance.error_message.is_a?(Array)
        %(#{e}<div class="invalid-feedback">#{instance.error_message.uniq.join(", ")}</div>).html_safe
      else
        %(#{e}<div class="invalid-feedback">#{instance.error_message}</div>).html_safe
      end
    end
  end
  html
end
