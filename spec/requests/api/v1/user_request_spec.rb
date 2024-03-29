require "rails_helper"
require "pry"
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe "User API" do
  describe "register a user" do
    describe "happy path" do
      it "creates a user", :vcr do
        params = {
          name: "Pabu",
          email: "pabu@pabu.com",
          username: "pabuisthebest",
          password: "pabu123",
          password_confirmation: "pabu123" }
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
        expect(user[:attributes][:logged_in]).to eq(false)
        expect(user[:attributes][:incognito_mode]).to eq(false)
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

        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("A field is blank")
      end
      it "an email is already taken", :vcr do
        register("Loki", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
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
        
        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("Email has already been taken")
      end
    end
  end

  describe "get a users info" do
    describe "happy path" do
      it "reterns correct user", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")

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
        expect(user[:attributes][:logged_in]).to eq(false)
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
        
        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("User can't be found")
      end
      it "email is missing", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")

        headers = { "Content-Type" => "application/json" }
        get "/api/v1/user", headers: headers
       
        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("User can't be found")

      end
    end
  end

  describe "login a user" do
    describe "happy path" do
      it "user is successfully logged in", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")

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
    describe "sad path" do 
      it "password isnt correct", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
        params = {
          email: "pabu@pabu.com",
          password: "loki321"
        }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/login", headers: headers, params: JSON.generate(params)

        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("Invalid Credentials")
      end
      it "email doesnt exist", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
        params = {
          email: "loki@pabu.com",
          password: "pabu123"
        }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/login", headers: headers, params: JSON.generate(params)

        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("Invalid Credentials")
      end
      it "filed is blank", :vcr do
        params = {
          email: "loki@pabu.com"
        }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/login", headers: headers, params: JSON.generate(params)

        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("A field is blank")
      end
    end
  end
  describe "logout a user" do
    describe "happy path" do
      it "user is successfully logged out", :vcr do
        register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
        login("pabu@pabu.com", "pabu123")
        user = User.find(1)

        expect(session[:user_id]).to eq(1)
        expect(user.logged_in).to be(true)
        
        params = {
          email: "pabu@pabu.com"
        }
        headers = { "Content-Type" => "application/json" }

        delete "/api/v1/logout", headers: headers, params: JSON.generate(params)
        
        expect(response).to be_successful
        expect(session[:user_id]).to be_nil
        
        user = User.find(1)
        expect(user.logged_in).to be(false)
      end
      it "user can log out and then back in", :vcr do 
        # Register user
        new_user = register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
        expect(new_user.logged_in).to be(false)

        # Log in user
        login("pabu@pabu.com", "pabu123")
        expect(response).to be_successful

        user = User.find(1)
        expect(user.logged_in).to be(true)

        expect(session[:user_id]).to eq(1)

        # Log out the user
        logout_params = {
          email: "pabu@pabu.com"
        }
        headers = { "Content-Type" => "application/json" }
        delete "/api/v1/logout", headers: headers, params: JSON.generate(logout_params)
        expect(response).to be_successful
        
        user = User.find(1)
        expect(user.logged_in).to be(false)
        
        expect(session[:user_id]).to be_nil

        # Log in user
        login("pabu@pabu.com", "pabu123")
        expect(response).to be_successful

        user = User.find(1)
        expect(user.logged_in).to be(true)

        expect(session[:user_id]).to eq(1)
      end
    end
    describe "sad path" do 
      it "field is blank", :vcr do
        user = register("Pabu", "pabu@pabu.com", "pabuisthebest", "pabu123", "pabu123")
        login("pabu@pabu.com", "pabu123")

        expect(session[:user_id]).to eq(1)

        headers = { "Content-Type" => "application/json" }


        delete "/api/v1/logout", headers: headers
        
        error_msg = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(response).to_not be_successful
        expect(error_msg[:error]).to eq("Something went wrong")
        expect(session[:user_id]).to eq(1)
        expect(user.logged_in).to be(false)
      end
    end
  end
end