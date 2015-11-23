module ApplicationHelper
  def menu_link(name, target, icon)
    css = target.to_s == request.original_fullpath ? 'active' : ''
    link_to(target, :class => css) do
      "<i class='fa fa-#{icon}'></i> #{name}".html_safe
    end
  end

  def human_date(datetime)
    datetime.strftime('%Y-%m-%d %H:%M')
  end
end
