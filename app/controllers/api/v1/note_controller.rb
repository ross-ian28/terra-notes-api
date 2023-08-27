class Api::V1::NoteController < ApplicationController
    def create
      note = Note.new(user_id: find_user_id(), contents: "", x_position: 0, y_position: 0)
      if note.save
        render json: NoteSerializer.get_note(note), status: 201
      else
        render json: ErrorSerializer.get_note_error("Something went wrong"), status: 400
      end
    end

    def update
        note = find_note()
        if note && note.update(note_params)
          render json: NoteSerializer.get_note(note), status: 201
        else
          render json: "Could not update note", status: 400
        end
      end

      def position
        note = find_note()
        if note && note.update(x_position: params[:x_position], y_position: params[:y_position])
          render json: NoteSerializer.get_note(note), status: 201
        else
          render json: "Could not update note position", status: 400
        end
      end

      def delete
        note = find_note()
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

    def find_note()
      Note.find_by(id: params[:id])
    end 

    def note_params
      params.permit(:id, :contents, :x_position, :y_position)
    end
  end