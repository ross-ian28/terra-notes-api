Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/register", to: "user#create"
      get "/user", to: "user#index"
    end
  end
end
