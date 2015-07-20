module DeviseHelper
  def devise_error_messages!
    return "<br>".html_safe if resource.errors.empty?

    resource.errors.full_messages.each do |msg|
      concat(content_tag(:div, msg, class: "alert alert-danger alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
          concat content_tag(:span, 'Close', class: 'sr-only')
        end)
        concat msg
      end)
    end
    nil
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end
