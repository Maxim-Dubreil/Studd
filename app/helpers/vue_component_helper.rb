module VueComponentHelper
  # Comment ajouter les composants :
  #     <%= vue_component 'UserAvatar', { name: 'Max' }, class: 'inline-block' %>
  def vue_component(name, props = {}, html_options = {})
    html_options = html_options.deep_merge(
      data: {
        vue_component: name,
        vue_props:     props.to_json
      }
    )
    content_tag(:div, '', html_options)
  end
end
