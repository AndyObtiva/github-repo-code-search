class Users::RegistrationsController < Devise::RegistrationsController
  def show
    render :show
  end
end