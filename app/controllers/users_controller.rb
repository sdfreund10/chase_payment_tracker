class UsersController < ApplicationController
  before_action :set_user, only: [:update]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user, status: :unprocessable_entity
    end
  end

  def update
    if current_user.is_admin? || @user == current_user
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

  def set_user
    @user = User.find_by(id: params[:id])
    render json: {}, status: :bad_request if @user.nil?
  end

  def update_user
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end
end
