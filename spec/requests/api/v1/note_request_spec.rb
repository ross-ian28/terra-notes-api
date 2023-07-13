require "rails_helper"
require "pry"

RSpec.describe "Notes API" do
  describe "create a note" do
    describe "happy path" do
      it "note is created", :vcr do
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        params = {
          user_id: user.id,
          contents: "Go to the pet store for ferret food" }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/new_note", headers: headers, params: JSON.generate(params)

        note = JSON.parse(response.body, symbolize_names: true)[:data]
        new_note = Note.last

        expect(response).to be_successful
        expect(note).to include :id, :type, :attributes
        expect(note[:id]).to eq(new_note.id)
        expect(note[:type]).to eq("notes")
        expect(note[:attributes]).to include :user_id, :contents
        expect(note[:attributes][:user_id]).to eq(new_note.user_id)
        expect(note[:attributes][:contents]).to eq(new_note.contents)
      end
    end
    describe "sad path" do 
      it "a field is missing", :vcr do
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        params = {
          user_id: user.id }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/new_note", headers: headers, params: JSON.generate(params)

        expect(response).to_not be_successful
        expect(response.body).to eq("Contents can't be blank") 
      end
    end
  end

  describe "edit a note" do
    describe "happy path" do
      it "edit note", :vcr do
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        note = Note.create(user_id: user.id, contents: "Ferret bag is full")
        params = {
          user_id: user.id,
          note_id: note.id,
          contents: "Go to the pet store for ferret food" }
        headers = { "Content-Type" => "application/json" }
        patch  "/api/v1/edit_note", headers: headers, params: JSON.generate(params)

        updated_note = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(response).to be_successful
        expect(updated_note).to include :id, :type, :attributes
        expect(updated_note[:id]).to eq(note.id)
        expect(updated_note[:type]).to eq("notes")
        expect(updated_note[:attributes][:user_id]).to eq(note.user_id)
        expect(updated_note[:attributes][:contents]).to eq("Go to the pet store for ferret food")
      end
    end
    describe "sad path" do 
      it "a field is missing", :vcr do
        user = User.create(name: "Pabu", email: "pabu@pabu.com", username: "pabuisthebest", password: "pabu123", password_confirmation: "pabu123", logged_in: true, incognito_mode: false)
        note = Note.create(user_id: user.id, contents: "Ferret bag is full")
        params = {
          user_id: user.id,
          contents: "Go to the pet store for ferret food" }
        headers = { "Content-Type" => "application/json" }
        patch  "/api/v1/edit_note", headers: headers, params: JSON.generate(params)
        
        expect(response).to_not be_successful
        expect(response.body).to eq("Could not update note")
      end
    end
  end
end