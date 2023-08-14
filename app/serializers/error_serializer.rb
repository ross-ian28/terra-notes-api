class ErrorSerializer
    def self.get_user_error(error_msg)
      {
        data: {
          type: "errors",
          error: error_msg
        }
      }
    end

    def self.get_note_error(error_msg)
      {
        data: {
          type: "notes",
          error: error_msg
        }
      }
    end
  end