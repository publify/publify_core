# frozen_string_literal: true

class Admin::SettingsController < Admin::BaseController
  VALID_ACTIONS = %w(index write feedback display).freeze

  def index
    this_blog.base_url = blog_base_url if this_blog.base_url.blank?
    load_settings
  end

  def write
    load_settings
  end

  def feedback
    load_settings
  end

  def display
    load_settings
  end

  def update
    load_settings
    if @setting.update(settings_params)
      load_lang
      flash[:success] = I18n.t("admin.settings.update.success")
      redirect_to action: action_param
    else
      flash[:error] = I18n.t("admin.settings.update.error",
                             messages: this_blog.errors.full_messages.join(", "))
      render action_param
    end
  end

  private

  def settings_params
    @settings_params ||= params.require(:setting).permit(@setting.settings_keys)
  end

  def action_param
    @action_param ||=
      begin
        value = params[:from]
        VALID_ACTIONS.include?(value) ? value : "index"
      end
  end

  def load_settings
    @setting = this_blog
  end
end
