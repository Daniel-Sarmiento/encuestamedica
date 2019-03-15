class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_devise_params, if: :devise_controller?

  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(:nombre, :apellido_paterno, :apellido_materno, :sexo, :fecha_nacimiento, :fecha_ingreso_universidad, :email, :password, :password_confirmation, :numero_trabajador)
    end
  end

  def authenticate_doctor
    redirect_to root_path, notice: 'Solo el Doctor puede acceder' unless user_signed_in? && current_user.is_doctor?
  end
  
end
