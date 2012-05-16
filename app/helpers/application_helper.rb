module ApplicationHelper
  def icon(icon_name = 'application', options = {})
    options.merge!(:class => "#{options[:class]} icon")
    image_tag("icons/#{icon_name}.png", options)
  end

  def page_title
    if breadcrumbs.items.length == 0
      'Cohort'
    else
      [breadcrumbs.items.collect{|i| i[0]}.reject{|i| i == 'Dashboard'}.reverse, 'Cohort'].flatten.compact.join(' :: ') 
    end
  end
end
