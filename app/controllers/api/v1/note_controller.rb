class Api::V1::NoteController < ApplicationController
    def create
      user_id = find_user_id()
      note = Note.new(user_id: user_id, contents: "New note")
      if note.save
        render json: NoteSerializer.get_note(note), status: 201
      else
        render json: ErrorSerializer.get_note_error("Something went wrong"), status: 400
      end
    end

    def update
        user = User.find_by(id: params[:user_id])
        note = user.notes.find_by(id: params[:note_id])
        if note && note.update(note_params)
          render json: NoteSerializer.get_note(note), status: 201
        else
          render json: "Could not update note", status: 400
        end
      end

      def delete

        user = User.find_by(id: params[:user_id])
        note = user.notes.find_by(id: params[:note_id])
        if note.delete
          render json: NoteSerializer.delete("Note deleted sucsessfully"), status: 201
        else
          render json: NoteSerializer.delete("Could not delete note"), status: 400
        end
      end
  
    private
  
    def find_user_id()
      User.find_by(email: params[:email]).id
    end 

    def note_params
      params.permit(:user_id, :contents)
    end
  end