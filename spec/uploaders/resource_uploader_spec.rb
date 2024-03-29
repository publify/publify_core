# frozen_string_literal: true

require "rails_helper"

RSpec.describe ResourceUploader do
  describe ".versions" do
    it "has three versions" do
      expect(described_class.versions.keys).to contain_exactly(:thumb, :medium, :avatar)
    end
  end
end
