class Api::V1::UserController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: UserSerializer.user(user), status: 201
    else
      render json: user.errors.full_messages.to_sentence.to_s, status: 400
    end
  end

  def index
    user = User.find_by(email: params[:email])
    if user
      render json: UserSerializer.user(user), status: 201
    else
      render json: user.errors.full_messages.to_sentence.to_s, status: 400
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: UserSerializer.user(user), status: 200
    else
      render json: 'Invalid info', status: 400
    end
  end

  def logout
    reset_session
    render json: 'Logged out successfully', status: 201
  end

  private

  def user_params
    params.permit(:name, :email, :username, :password, :password_confirmation, :logged_in, :incognito_mode)
  end
end