# frozen_string_literal: true

require "rails_helper"

RSpec.describe SetupController, type: :controller do
  let(:strong_password) { "fhnehnhfiiuh" }

  describe "#index" do
    describe "when blog is not configured" do
      before do
        # Set up database similar to result of db:setup
        Blog.create
        get "index"
      end

      specify { expect(response).to render_template("index") }
    end

    describe "when a blog is configured and has some users" do
      before do
        create(:blog)
        get "index"
      end

      specify { expect(response).to redirect_to(controller: "articles", action: "index") }
    end
  end

  describe "#create" do
    context "when blog is not configured" do
      # Set up database similar to result of seeding
      let!(:blog) { Blog.create }

      context "when passing correct parameters" do
        before do
          ActionMailer::Base.deliveries.clear
          post :create, params: { blog: { blog_name: "Foo" },
                                  user: { email: "foo@bar.net",
                                          password: strong_password } }
        end

        it "correctly initializes blog and users" do
          admin = User.find_by(login: "admin")

          aggregate_failures do
            expect(Blog.first.blog_name).to eq("Foo")
            expect(admin).not_to be_nil
            expect(admin.email).to eq("foo@bar.net")
            expect(Article.first.user).to eq(admin)
            expect(Page.first.user).to eq(admin)
          end
        end

        it "logs in admin user" do
          expect(controller.current_user).to eq(User.find_by(login: "admin"))
        end

        it "redirects to confirm the setup" do
          expect(response).to redirect_to(controller: "accounts",
                                          action: "confirm")
        end

        it "sends a confirmation email" do
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
      end

      context "when passing incorrect parameters" do
        it "does no setup when blog name is empty" do
          post :create, params: { blog: { blog_name: "" },
                                  user: { email: "foo@bar.net",
                                          password: strong_password } }
          aggregate_failures do
            expect(response).to render_template "index"
            expect(blog.reload).not_to be_configured
          end
        end

        it "does no setup when email is empty" do
          post :create, params: { blog: { blog_name: "Foo" },
                                  user: { email: "",
                                          password: strong_password } }
          aggregate_failures do
            expect(response).to render_template "index"
            expect(blog.reload).not_to be_configured
          end
        end

        it "does no setup when password is empty" do
          post :create, params: { blog: { blog_name: "Foo" },
                                  user: { email: "foo@bar.net",
                                          password: "" } }
          aggregate_failures do
            expect(response).to render_template "index"
            expect(blog.reload).not_to be_configured
          end
        end

        it "does no setup when password is weak" do
          post :create, params: { blog: { blog_name: "Foo" },
                                  user: { email: "foo@bar.net",
                                          password: "foo123bar" } }
          aggregate_failures do
            expect(response).to render_template "index"
            expect(blog.reload).not_to be_configured
          end
        end
      end
    end

    describe "when a blog is configured and has some users" do
      before do
        create(:blog)
        post :create, params: { blog: { blog_name: "Foo" },
                                user: { email: "foo@bar.net" } }
      end

      specify { expect(response).to redirect_to(controller: "articles", action: "index") }

      it "does not initialize blog and users" do
        expect(Blog.first.blog_name).not_to eq("Foo")
        admin = User.find_by(login: "admin")
        expect(admin).to be_nil
      end
    end
  end
end
