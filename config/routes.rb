Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #User endpoints
      post "/register", to: "user#create" #create/register a user
      get "/user", to: "user#index" #get user information
      post "/login", to: "user#login" #login a user/create a session
      delete "/logout", to: "user#logout" #logout a user/delete a session

      #Note endpoints
      post "/new_note", to: "note#create" #create a note
      patch "/edit_note", to: "note#update" #edit a note
      patch "/edit_note_position", to: "note#position" #change a notes position
      delete "/delete_note", to: "note#delete" #delete a note
    end
  end
end
