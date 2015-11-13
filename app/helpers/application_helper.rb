module ApplicationHelper
  def menu_link(name, controller)
    css = controller.to_s == params[:controller] ? 'active' : ''
    link_to(name, controller, :class => css)
  end
end
