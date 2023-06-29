class NoteSerializer
    def self.get_note(note)
      {
        data: {
          type: "notes",
          id: note.id,
          attributes: {
            user_id: note.user_id,
            contents: note.contents
          }
        }
      }
    end
  end