class Api::V1::RegisterController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: UserSerializer.create_user(user), status: 201
    else
      render json: user.errors.full_messages.to_sentence.to_s, status: 400
    end
  end

  def index 
  end

  private

  def user_params
    params.permit(:name, :email, :username, :password, :password_confirmation, :logged_in, :incognito_mode)
  end
end