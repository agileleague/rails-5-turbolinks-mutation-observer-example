module HomeHelper
  def color_tag(color, code: nil)
    code ||= color
    content_tag(:div, color, "data-color" => color)
  end
end
