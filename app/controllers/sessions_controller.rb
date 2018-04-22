class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: session_params[:email])
    if @user.present? && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      render json: {}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
