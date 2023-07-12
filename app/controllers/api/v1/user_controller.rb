class Api::V1::UserController < ApplicationController

  def create
    if params[:name].present? && params[:email].present? && params[:username].present? && params[:password].present? && params[:password_confirmation].present?
      user = User.new(user_params)
      if user.save
        session[:user_id] = user.id
        render json: UserSerializer.get_user(user), status: 201
      else
        render json: user.errors.full_messages.to_sentence.to_s, status: 400
      end
    else
      render json: "Email can't be blank", status: 400
    end
  end

  def index
    if params[:email].present? 
      user = User.find_by(email: params[:email])
      if user
        render json: UserSerializer.get_user(user), status: 201
      elsif user == nil
        render json: "User can't be found", status: 400
      else
        render json: user.errors.full_messages.to_sentence.to_s, status: 400
      end
    else 
      render json: "User can't be found", status: 400
    end
  end

  def login
    if params[:email].present? && params[:password].present?
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        user.logged_in = true
        if user.save
          render json: UserSerializer.get_user(user), status: 201
        else 
          render json: "Couldn't log in", status: 400
        end
      else
        render json: 'Invalid Info', status: 400
      end
    else 
      render json: 'Email or Password is blank', status: 400
    end
  end
  
  def logout
    if params[:email].present?
      user = User.find_by(email: params[:email])
      #Change the logged_in field to false and 
      session[:user_id] = nil 
      user.logged_in = false
      if user.save
        render json: 'Logged out successfully', status: 201
      else 
        render json: "Can't log out", status: 400
      end
    else 
      render json: 'Something went wrong', status: 400
    end
  end

  private
  def user_params
    params.permit(:name, :email, :username, :password, :password_confirmation, :logged_in, :incognito_mode)
  end
end