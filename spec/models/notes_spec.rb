require "rails_helper"
require 'shoulda/matchers'

RSpec.describe Note, type: :model do
  describe "validations" do
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :contents }
  end
  describe "relationships" do
    it { should belong_to(:user) }
  end
end