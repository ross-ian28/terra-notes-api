Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/register", to: "user#create" #create/register a user
      get "/user", to: "user#index" #get user information
      post "/login", to: "user#login" #login a user/create a session
      delete "/logout", to: "user#logout" #logout a user/delete a session
    end
  end
end
