module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    concat(content_tag(:div, class: "alert alert-danger alert-dismissible", role: 'alert') do
      concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
        concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => true)
        concat content_tag(:span, 'Close', class: 'sr-only')
      end)
      resource.errors.full_messages.each do |msg|
        concat "#{msg}.<br>".html_safe
      end
    end)
    nil
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end
