# frozen_string_literal: true

module Admin::BaseHelper
  include ActionView::Helpers::DateHelper

  def toggle_element(element, label = t("generic.change"))
    link_to label, "##{element}", data: { toggle: :collapse }
  end

  def class_for_admin_state(sidebar, this_position)
    case sidebar.admin_state
    when :active
      "active alert-info"
    when :will_change_position
      if this_position == sidebar.active_position
        "will_change ghost"
      else
        "will_change alert-warning"
      end
    else
      raise sidebar.admin_state.inspect
    end
  end

  def text_filter_options
    TextFilter.all.map do |filter|
      [filter.description, filter.name]
    end
  end

  def plugin_options(kind)
    PublifyPlugins::Keeper.available_plugins(kind).map do |plugin|
      [plugin.name, plugin.to_s]
    end
  end

  def show_actions(item)
    tag.div(class: "action", style: "") do
      safe_join [button_to_edit(item),
                 button_to_delete(item),
                 button_to_short_url(item)], " "
    end
  end

  def display_pagination(collection, cols, _first = "", _last = "")
    return if collection.none?

    tag.tr do
      tag.td(paginate(collection), class: "paginate", colspan: cols)
    end
  end

  def button_to_edit(item)
    link_to(t("generic.edit"),
            { action: "edit", id: item.id },
            { class: "btn btn-primary btn-xs btn-action" })
  end

  def button_to_delete(item)
    confirm_text = t("admin.shared.destroy.are_you_sure",
                     element: item.class.model_name.human.downcase)
    link_to(t("generic.delete"),
            { action: "destroy", id: item.id },
            { class: "btn btn-danger btn-xs btn-action", method: :delete,
              data: { confirm: confirm_text } })
  end

  def button_to_short_url(item)
    return "" if item.short_url.nil?

    link_to(t("generic.short_url"), item.short_url,
            class: "btn btn-success btn-xs btn-action")
  end

  def twitter_available?(blog, user)
    blog.has_twitter_configured? && user.has_twitter_configured?
  end

  def menu_item(name, url)
    if current_page? url
      tag.li(link_to(name, "#"), class: "active")
    else
      tag.li(link_to(name, url))
    end
  end
end
