class RegistrationsController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      render "users/show", status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit :email_address, :password, :password_confirmation
    end
end
