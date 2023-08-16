class Api::V1::UserController < ApplicationController
  def create
    if params[:name].present? && params[:email].present? && params[:password].present?
      user = User.new(user_params)
      if user.save
        render json: UserSerializer.get_user(user), status: 201
      else
        render json: ErrorSerializer.get_user_error(user.errors.full_messages.to_sentence.to_s), status: 400
      end
    else
      render json: ErrorSerializer.get_user_error("A field is blank"), status: 400
    end
  end

  def index
    if params[:email].present? 
      user = User.find_by(email: params[:email])
      if user && session
        render json: UserSerializer.get_user(user), status: 201
      else
        render json: ErrorSerializer.get_user_error("User can't be found"), status: 400
      end
    else 
      render json: ErrorSerializer.get_user_error("User can't be found"), status: 400
    end
  end

  def login
    if params[:email].present? && params[:password].present?
      if user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          user.logged_in = true
          if user.save
            render json: UserSerializer.get_user(user), status: 201
          else 
            render json: ErrorSerializer.get_user_error("Something went wrong"), status: 400
          end
        else
          render json: ErrorSerializer.get_user_error("Invalid Credentials"), status: 400
        end
      else 
        render json: ErrorSerializer.get_user_error("Email not registered"), status: 400
      end
    else 
      render json: ErrorSerializer.get_user_error("A field is blank"), status: 400
    end
  end
  
  def logout
    if params[:email].present?
      user = User.find_by(email: params[:email])
      session[:user_id] = nil 
      user.logged_in = false
      if user.save
        render json: UserSerializer.logout("Logged out successfully"), status: 201
      else 
        render json: ErrorSerializer.get_user_error("Couldn't logout"), status: 400
      end
    else 
      render json: ErrorSerializer.get_user_error("Something went wrong"), status: 400
    end
  end

  private
  def user_params
    params.permit(:name, :email, :username, :password, :logged_in, :incognito_mode)
  end
end