# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThemeController, type: :controller do
  before { create(:blog, theme: "plain") }

  it "test_stylesheets" do
    get :stylesheets, params: { filename: "theme.css" }
    assert_response :success
    expect(@response.media_type).to eq "text/css"
    expect(@response.charset).to eq "utf-8"
    expect(@response.headers["Content-Disposition"]).
      to eq 'inline; filename="theme.css"; filename*=UTF-8\'\'theme.css'
  end

  it "test_javascripts" do
    get :javascripts, params: { filename: "theme.js" }
    assert_response :success
    expect(@response.media_type).to eq "text/javascript"
    expect(@response.charset).to eq "utf-8"
    expect(@response.headers["Content-Disposition"]).
      to eq 'inline; filename="theme.js"; filename*=UTF-8\'\'theme.js'
  end

  it "test_malicious_path" do
    get :stylesheets, params: { filename: "../../../config/database.yml" }
    expect(response).to be_not_found
    expect(response.media_type).to eq "text/plain"
  end

  it "renders 404 for missing file" do
    get :stylesheets, params: { filename: "foo.css" }
    expect(response).to be_not_found
    expect(response.media_type).to eq "text/plain"
  end
end
