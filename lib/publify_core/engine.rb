# frozen_string_literal: true

module PublifyCore
  class Engine < ::Rails::Engine
    config.generators do |generators|
      generators.test_framework :rspec, fixture: false
      generators.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.to_prepare do
      DeviseController.layout "accounts"
      DeviseController.before_action do
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
      end
    end

    initializer "publify_core.assets" do |app|
      Theme.find_each do |theme|
        app.config.assets.paths << theme.path.join("fonts")
        app.config.assets.paths << theme.path.join("images")
        app.config.assets.paths << theme.path.join("javascripts")
        app.config.assets.paths << theme.path.join("stylesheets")
      end
    end

    initializer "publify_core.assets.precompile" do |app|
      app.config.assets.precompile += %w(
        publify.js
        publify.css
        publify_admin.js
        publify_admin.css
        accounts.css
        bootstrap.css
        user-styles.css
        spinner-blue.gif
        spinner.gif
      )
      Theme.find_each do |theme|
        path = theme.path

        dir = path.join("fonts")
        app.config.assets.precompile +=
          dir.glob("#{theme.name}/*.*").map { _1.relative_path_from(dir).to_s }

        dir = path.join("images")
        app.config.assets.precompile +=
          dir.glob("#{theme.name}/*.*").map { _1.relative_path_from(dir).to_s }

        dir = path.join("javascripts")
        app.config.assets.precompile +=
          dir.glob("#{theme.name}/*.js").map { _1.relative_path_from(dir).to_s }

        dir = path.join("stylesheets")
        app.config.assets.precompile +=
          dir.glob("#{theme.name}/*.css").map { _1.relative_path_from(dir).to_s }
      end
    end
  end
end
