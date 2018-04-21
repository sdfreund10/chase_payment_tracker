class UsersController < ApplicationController
  before_action :set_user, only: [:update]
  before_action :set_requester, only: [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user, status: :unprocessable_entity
    end
  end

  def update
    if @user.nil? || @requester.nil?
      render json: {}, status: :bad_request
    elsif @requester&.is_admin? || @user&.token == params[:token]
      update_user
    else
      render json: {}, status: :forbidden
    end
  end

  private

  def user_params
    params.require(:user).
           permit(:name, :email, :password, :password_confirmation)
  end

  def set_requester
    @requester = User.find_by(token: params[:token])
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def update_user
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end
end
