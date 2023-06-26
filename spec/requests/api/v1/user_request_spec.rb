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
    describe "sad path" do 
      it "a field is missing", :vcr do
        params = {
          name: "Pabu",
          username: "pabuisthebest",
          password: "pabu123",
          password_confirmation: "pabu123",
          logged_in: true,
          incognito_mode: false }
        headers = { "Content-Type" => "application/json" }

        post "/api/v1/register", headers: headers, params: JSON.generate(params)

        expect(response).to_not be_successful
        expect(response.body).to eq("Email can't be blank")
      end
      it "an email is already taken", :vcr do
        User.create(name: "Loki", email: "pabu@pabu.com", username: "lokiisthebest", password: "loki123", password_confirmation: "loki123", logged_in: true, incognito_mode: false)
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
        
        expect(response).to_not be_successful
        expect(response.body).to eq("Email has already been taken")
      end
      it "passwords dont match", :vcr do
        params = {
          name: "Pabu",
          email: "pabu@pabu.com",
          username: "pabuisthebest",
          password: "pabu123",
          password_confirmation: "pabu",
          logged_in: true,
          incognito_mode: false }
        headers = { "Content-Type" => "application/json" }

        post "/api/v1/register", headers: headers, params: JSON.generate(params)
        
        expect(response).to_not be_successful
        expect(response.body).to eq("Password confirmation doesn't match Password")
      end
    end
  end

  describe "get a users info" do
    describe "happy path" do
      it "reterns correct user", :vcr do
        User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)

        headers = { "Content-Type" => "application/json" }

        get "/api/v1/user", headers: headers, params: { email: "pabu@pabu.com" }

        user = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(response).to be_successful

        expect(user).to include :id, :type, :attributes
        expect(user[:type]).to eq("users")
        expect(user[:attributes]).to include :email, :username, :logged_in, :incognito_mode
        expect(user[:attributes][:name]).to eq("Pabu")
        expect(user[:attributes][:email]).to eq("pabu@pabu.com")
        expect(user[:attributes][:username]).to eq("pabuisthebest")
        expect(user[:attributes][:logged_in]).to eq(true)
        expect(user[:attributes][:incognito_mode]).to eq(false)
      end
    end
    describe "sad path" do 
      it "no user is found", :vcr do
        params = {
          name: "Pabu",
          email: "pabu@pabu.com",
          username: "pabuisthebest"
        }
        headers = { "Content-Type" => "application/json" }

        get "/api/v1/user", headers: headers, params: { email: "pabu@pabu.com" }
        
        expect(response).to_not be_successful

        expect(response.body).to eq("User can't be found")
      end
      it "email is missing", :vcr do
        User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        headers = { "Content-Type" => "application/json" }

        get "/api/v1/user", headers: headers
       
        expect(response).to_not be_successful

        expect(response.body).to eq("User can't be found")
      end
    end
  end

  describe "login a user" do
    describe "happy path" do
      before :each do
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
      end
      it "user is successfully logged in", :vcr do
        params = {
          email: "pabu@pabu.com",
          password: "pabu123"
        }
        headers = { "Content-Type" => "application/json" }

        post "/api/v1/login", headers: headers, params: JSON.generate(params)

        user = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        
        expect(user).to include :id, :type, :attributes
        expect(user[:type]).to eq("users")
        expect(user[:attributes]).to include :email, :username, :logged_in, :incognito_mode
        expect(user[:attributes][:email]).to eq("pabu@pabu.com")
        expect(user[:attributes][:username]).to eq("pabuisthebest")
        expect(user[:attributes][:logged_in]).to eq(true)
        expect(user[:attributes][:incognito_mode]).to eq(false)
      end
    end
  #   describe "sad path" do 
  #     it "password isnt correct", :vcr do
  #       #if email exists but password doesn't match
  #     end
  #     it "email doesnt exist", :vcr do
  #       #if the email isn't registered
  #     end
  #     it "filed is blank", :vcr do
  #     end
    # end
  end
  describe "logout a user" do
    describe "happy path" do
      before :each do
        #Register user
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        #Login User
        params = { email: "pabu@pabu.com", password: "pabu123" }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/login", headers: headers, params: JSON.generate(params)
      end
      it "user is successfully logged out", :vcr do
        expect(session[:user_id]).to eq(1)

        params = {
          email: "pabu@pabu.com",
          password: "pabu123"
        }
        headers = { "Content-Type" => "application/json" }

        delete "/api/v1/logout", headers: headers, params: { email: "pabu@pabu.com" }

        expect(response).to be_successful
        expect(session[:user_id]).to be_nil
      end
    end
  #   describe "sad path" do 
  #     it "field is blank", :vcr do
  #     end
    # end
  end
end