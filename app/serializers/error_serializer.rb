class ErrorSerializer
    def self.get_error(error_msg)
      {
        data: {
          type: "errors",
          error: error_msg
        }
      }
    end
  end