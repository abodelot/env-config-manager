module ApplicationHelper
  def menu_link(name, controller)
    css = controller.to_s == params[:controller] ? 'active' : ''
    link_to(name, controller, :class => css)
  end

  def human_date(datetime)
    datetime.strftime('%Y-%m-%d %H:%M')
  end
end
