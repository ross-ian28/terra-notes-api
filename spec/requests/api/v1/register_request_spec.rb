require "rails_helper"
require "pry"

RSpec.describe 'Register User API' do
  describe "happy path" do 
    it 'creates a user', :vcr do
      params = {
        name: "Pabu",
        email: "pabu@pabu.com",
        username: "pabuisthebest",
        password: "pabu123",
        password_confirmation: "pabu123",
        logged_in: true,
        incognito_mode: false
    }
      headers = { "Content-Type" => "application/json" }

      post "/api/v1/register", headers: headers, params: JSON.generate(params)
      binding.pry
      user = JSON.parse(response.body, symbolize_names: true)[:data]
      new_user = User.last
      binding.pry
      expect(response).to be_successful

      expect(user).to include :id, :type, :attributes
      expect(user[:id]).to eq(new_user.id)
      expect(user[:type]).to eq("users")
      expect(user[:attributes]).to include :email, :username, :logged_in, :incognito_mode
      expect(user[:attributes][:email]).to eq(new_user.email)
      expect(user[:attributes][:username]).to eq(new_user.username)
      expect(user[:attributes][:logged_in]).to eq(new_user.logged_in)
      expect(user[:attributes][:incognito_mode]).to eq(new_user.incognito_mode)
    end
  end
end