class UserSerializer
  def self.get_user(user)
    {
      data: {
        type: "users",
        id: user.id,
        attributes: {
          name: user.name,
          email: user.email,
          username: user.username,
          logged_in: user.logged_in,
          incognito_mode: user.incognito_mode,
          notes: user.notes.map do |note|  # Use user.notes instead of just notes
            {
              id: note.id,
              type: "notes",
              attributes: {
                user_id: note.user_id,
                contents: note.contents,
                x_position: note.x_position,
                y_position: note.y_position
              }
            }
          end
        }
      }
    }
  end

  def self.logout(msg)
    {
      data: {
        type: "users",
        msg: msg
      }
    }
  end
end
