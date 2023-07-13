class Api::V1::NoteController < ApplicationController
    def create
      note = Note.new(note_params)
      if note.save
        render json: NoteSerializer.get_note(note), status: 201
      else
        render json: note.errors.full_messages.to_sentence.to_s, status: 400
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
  
    private
  
    def note_params
      params.permit(:user_id, :contents)
    end
  end