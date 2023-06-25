class UserSerializer
    def self.create_user(user)
      {
        data: {
          type: "users",
          id: user.id,
          attributes: {
            email: user.email,
            username: user.username,
            logged_in: user.logged_in,
            incognito_mode: user.incognito_mode
          }
        }
      }
    end

    def self.get_user(user)
      {
        data: {
          type: "user",
          id: user.id,
          attributes: {
            email: user.email,
            username: user.username,
            logged_in: user.logged_in,
            incognito_mode: user.incognito_mode
          }
        }
      }
    end
  end