# frozen_string_literal: true

require "rails_helper"

RSpec.describe Redirect, type: :model do
  describe "#from_url" do
    it "is based on the blog's base_url" do
      blog = Blog.new(base_url: "https://quuz.bar/foo")
      redirect = blog.redirects.build(from_path: "right/here", to_path: "over_there")
      expect(redirect.from_url).to eq "#{blog.base_url}/right/here"
    end
  end

  describe "#full_to_path" do
    it "returns to_path if it includes an http or https scheme" do
      blog = Blog.new(base_url: "https://quuz.bar/")
      redirect = described_class.new(to_path: "https://foo.baz/", blog: blog)
      expect(redirect.full_to_path).to eq "https://foo.baz/"
    end

    it "includes the blog's root path" do
      blog = Blog.new(base_url: "https://quuz.bar/foo")
      redirect = described_class.new(to_path: "baz", blog: blog)
      expect(redirect.full_to_path).to eq "/foo/baz"
    end

    it "makes malicious target paths safe" do
      blog = Blog.new(base_url: "https://quuz.bar/")
      redirect = described_class.new(to_path: "javascript:alert()", blog: blog)
      expect(redirect.full_to_path).to eq "/javascript:alert()"
    end

    it "ignores the blog's root path if it is included in the redirect" do
      blog = Blog.new(base_url: "https://quuz.bar/foo")
      redirect = described_class.new(to_path: "/foo/baz", blog: blog)
      expect(redirect.full_to_path).to eq "/foo/baz"
    end
  end

  describe "validations" do
    let(:redirect) { described_class.new }

    it "requires from_path to not be too long" do
      expect(redirect).to validate_length_of(:from_path).is_at_most(255)
    end

    it "requires to_path to not be too long" do
      expect(redirect).to validate_length_of(:to_path).is_at_most(255)
    end

    it "requires redirects to be unique" do
      blog = create(:blog)
      blog.redirects.create!(from_path: "foo/bar", to_path: "/")

      redirect = blog.redirects.build(from_path: "foo/bar", to_path: "/")

      aggregate_failures do
        expect(redirect).not_to be_valid
        expect(redirect.errors[:from_path]).to eq(["has already been taken"])
      end
    end
  end
end
