require "rails_helper"
require "pry"

RSpec.describe "Notes API" do
  describe "create a notes" do
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
      end
      it "an email is already taken", :vcr do
      end
      it "passwords dont match", :vcr do
      end
    end
  end
end 