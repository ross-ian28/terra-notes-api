module UserHelpers
    def register(name, email, username, password, password_confirmation)
        User.create(name: name, email: email, username: username, password: password, password_confirmation: password_confirmation, logged_in: true, incognito_mode: false)
    end

    def login(email, password)
        params = { email: email, password: password }
        headers = { "Content-Type" => "application/json" }
        post "/api/v1/login", headers: headers, params: JSON.generate(params)
    end
  end