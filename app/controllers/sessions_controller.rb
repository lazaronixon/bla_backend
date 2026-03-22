class SessionsController < ApplicationController
  skip_before_action :authenticate

  SESSION_DURATION = 2.weeks

  def create
    if @user = User.authenticate_by(email_address: params[:email_address], password: params[:password])
      response.set_header "X-Session-Token", @user.signed_id(expires_in: SESSION_DURATION)
      response.set_header "X-Session-Expires-In", SESSION_DURATION
      render "users/show", status: :created
    else
      render json: { error: "That email or password is incorrect" }, status: :unauthorized
    end
  end

  def destroy
    render plain: "X-Session-Token expires in 15 minutes, forget this token!"
  end
end
