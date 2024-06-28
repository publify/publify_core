# frozen_string_literal: true

class Admin::ThemesController < Admin::BaseController
  def index
    @themes = Theme.find_all
    @active = this_blog.current_theme
  end

  def preview
    theme = Theme.find(params[:theme])
    send_file theme.theme_file("preview.png"),
              type: "image/png", disposition: "inline", stream: false
  end

  def switchto
    this_blog.theme = params[:theme]
    this_blog.save
    this_blog.current_theme(:reload)
    flash[:success] = I18n.t("admin.themes.switchto.success")
    redirect_to admin_themes_url
  end
end
