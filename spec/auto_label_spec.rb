# frozen_string_literal: true

require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerAutoLabel do
    it "should be a plugin" do
      expect(Danger::DangerAutoLabel.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.auto_label
      end
    end
  end
end
