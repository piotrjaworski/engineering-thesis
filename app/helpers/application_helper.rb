module ApplicationHelper
  def bootstrap_class_for(flash_type)
    { success: "alert-success", error: "alert-danger", alert: "alert-danger", notice: "alert-success" }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat message
      end)
    end
    nil
  end

  def errors_for(object)
    return unless object.errors.any?
    content_tag(:div, class: "panel panel-danger") do
      concat(content_tag(:div, class: "panel-heading") do
        concat(content_tag(:h4, class: "panel-title") do
          concat "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} from being saved:"
        end)
      end)
      concat(content_tag(:div, class: "panel-body") do
        concat(content_tag(:ul) do
          object.errors.full_messages.each do |msg|
            concat content_tag(:li, msg)
          end
        end)
      end)
    end
  end

  def user_image_class(user, topic)
    user.id == topic.creator_id ? "round-image-creator main-page-image" : "round-image main-page-image"
  end

  def fa_icon_with_text(text, icon)
    "#{text} #{fa_icon icon}".html_safe
  end

  def category_box(category)
    "<div style='margin-top: 3px; width: 12px; height: 12px; background-color:#{category.color};'></div>".html_safe
  end
end
