require "rails_helper"

RSpec.describe User, type: :model do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:logged_in) }
    it { should validate_presence_of(:incogneto_mode) }

  describe 'relationships' do
    it { should have_many(:notes) }
    it { should have_many(:docs) }
  end
end