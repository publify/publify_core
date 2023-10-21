# frozen_string_literal: true

class SetupController < BaseController
  before_action :check_config
  layout "accounts"

  def index
    @user = User.new
  end

  def create
    this_blog.blog_name = blog_params[:blog_name]
    this_blog.base_url = blog_base_url

    @user = User.new(user_params.merge(login: "admin",
                                       text_filter_name: this_blog.text_filter,
                                       nickname: "Publify Admin"))
    @user.name = @user.login

    return render :index unless this_blog.valid? && @user.valid?

    this_blog.save!
    @user.save!

    sign_in @user

    if User.count == 1
      create_first_post @user
      create_first_page @user
    end

    EmailNotify.send_user_create_notification(@user)

    redirect_to confirm_accounts_url
  end

  private

  def blog_params
    params.require(:blog).permit(:blog_name)
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def create_first_post(user)
    this_blog.articles.build(title: I18n.t("setup.article.title"),
                             author: user.login,
                             body: I18n.t("setup.article.body"),
                             allow_comments: 1,
                             allow_pings: 1,
                             user: user).publish!
  end

  def create_first_page(user)
    this_blog.pages.create(name: "about",
                           state: "published",
                           title: I18n.t("setup.page.about"),
                           user: user,
                           body: I18n.t("setup.page.body"))
  end

  def check_config
    return unless this_blog.configured?

    redirect_to controller: "articles", action: "index"
  end
end
