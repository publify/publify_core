# frozen_string_literal: true

class Theme
  attr_reader :name, :path

  def initialize(name, path)
    @name = name
    @path = Pathname.new path
  end

  def description
    @description ||=
      begin
        about_file = theme_file("about.markdown")
        if File.exist? about_file
          File.read about_file
        else
          "### #{name}"
        end
      end
  end

  def description_html
    TextFilter.markdown.filter_text(description)
  end

  def view_path
    "#{path}/views"
  end

  def theme_file(filename)
    File.join(path, filename)
  end

  def assets
    list_assets("fonts", "*.*") +
      list_assets("images", "*.*") +
      list_assets("javascripts", "*.js") +
      list_assets("stylesheets", "*.css")
  end

  def asset_paths
    [
      path.join("fonts"),
      path.join("images"),
      path.join("javascripts"),
      path.join("stylesheets")
    ]
  end

  private

  def list_assets(type, glob)
    dir = path.join type
    dir.glob("#{name}/#{glob}").map { _1.relative_path_from(dir).to_s }
  end

  class << self
    # Find a theme, given the theme name
    def find(name)
      registered_themes[name]
    end

    # List all themes
    def find_all
      registered_themes.values
    end

    def find_each
      find_all.each { yield _1 }
    end

    def register_theme(path)
      theme = theme_from_path(path)
      registered_themes[theme.name] = theme
    end

    def register_themes(themes_root)
      search_theme_directory(themes_root).each do |path|
        register_theme path
      end
    end

    private

    def registered_themes
      @registered_themes ||= {}
    end

    def theme_from_path(path)
      name = File.basename(path)
      new(name, path)
    end

    def search_theme_directory(themes_root)
      glob = "#{themes_root}/[a-zA-Z0-9]*"
      Dir.glob(glob).select do |file|
        File.readable?("#{file}/about.markdown")
      end.compact
    end
  end
end
