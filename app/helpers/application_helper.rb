module ApplicationHelper
  def icon(icon_name = 'application', alt = 'icon')
    image_tag("icons/#{icon_name}.png", :alt => alt, :class => "icon")
  end
end
