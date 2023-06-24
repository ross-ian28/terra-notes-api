require "rails_helper"
require "pry"

RSpec.describe "User API" do
  describe "register a user" do
    describe "happy path" do
      it "creates a user", :vcr do
        params = {
          name: "Pabu",
          email: "pabu@pabu.com",
          username: "pabuisthebest",
          password: "pabu123",
          password_confirmation: "pabu123",
          logged_in: true,
          incognito_mode: false }
        headers = { "Content-Type" => "application/json" }

        post "/api/v1/register", headers: headers, params: JSON.generate(params)

        user = JSON.parse(response.body, symbolize_names: true)[:data]
        new_user = User.last

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
  #   describe "sad path" do 
  #     it "a field is missing", :vcr do
  #     end
  #     it "an email is already taken", :vcr do
  #     end
  #     it "passwords dont match", :vcr do
  #     end
  #   end
  # end

  # describe "get a users info" do
  #   describe "happy path" do
  #     it "reterns correct user", :vcr do
  #     end
  #   end
  #   describe "sad path" do 
  #     it "no user is found", :vcr do
  #     end
  #     it "a field is blank", :vcr do
  #     end
  #   end
  # end

  # describe "login a user" do
  #   describe "happy path" do
  #     it "user is succsesffuly logged in", :vcr do
  #     end
  #   end
  #   describe "sad path" do 
  #     it "password isnt correct", :vcr do
  #       #if email exists but password doesn't match
  #     end
  #     it "email doesnt exist", :vcr do
  #       #if the email isn't registered
  #     end
  #     it "filed is blank", :vcr do
  #     end
  #   end
  end
end