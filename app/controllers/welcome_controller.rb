class WelcomeController < ApplicationController
  before_action :authenticate_doctor, only: [:patients_list, :patient_list_in_wait]
  before_action :set_enable_navigation
  before_action :set_fondo_all_page
  before_action :set_notifications_count
  skip_before_action :verify_authenticity_token, only: [:create_notification, :update_history]

  def index     
  end

  def my_date
    citas_in_wait = MedicalHistory.where(user_id: current_user, state: "in_wait").count
    citas_accepts = MedicalHistory.where(user_id: current_user, state: "accepted").count
    if citas_in_wait > 0 || citas_accepts > 0
      redirect_to notificaciones_path, notice: 'No puedes solicitar una cita. Tienes un cita pendiente'
    end
  end
  def my_appointments
    number_of_citas_in_wait = MedicalHistory.where(user_id: current_user, state: "in_wait").count
    number_of_citas_accepted = MedicalHistory.where(user_id: current_user, state: "accepted").count
    if number_of_citas_in_wait > 0
      @modo = 0
      @medical_history = MedicalHistory.where(user_id: current_user, state: "in_wait").first
      flash[:notice] = "Tu cita no todavia no ha sido aceptada. Puede editar tus datos."
    elsif number_of_citas_accepted > 0
      @modo = 1
      @medical_history = MedicalHistory.where(user_id: current_user, state: "accepted").first
      flash[:notice] = "Tu cita ha sido aceptada. No puedes editar tus datos."
    else
      redirect_to mi_cita_path, notice: 'No Has solicitado ninguna cita'
    end
  end

  def notifications_list
    @notifications_list = Notification.for_user(current_user);
    if !user_signed_in?
      @enable_navigation = false
       @fondo_all_page = false
      redirect_to new_user_session_path
      return
    end
  end

  def patients_list
      @patients = User.list_patients.paginate(page: params[:page], per_page: 6)
  end

  def update_history
    @medical_history = MedicalHistory.where(user_id: current_user, state: "in_wait").first
    @medical_history.respuestas_parte_uno = params[:respuestas_parte_uno] 
  end


  def patient_list_in_wait
    @medical_histories = MedicalHistory.list_in_wait.paginate(page: params[:page], per_page: 6)
  end

  def search
    palabra = "%#{params[:keyword]}%"
    @patients = User.where("nombre LIKE ? OR apellido_paterno LIKE ? OR apellido_materno LIKE ? OR numero_trabajador LIKE ?", palabra, palabra, palabra, palabra).paginate(page: params[:page], per_page: 4)
  end
  def search_in_medical_history
    palabra = "%#{params[:keyword]}%"
    patients = User.where("nombre LIKE ? OR apellido_paterno LIKE ? OR apellido_materno LIKE ?", palabra, palabra, palabra)
    @medical_histories = MedicalHistory.where(user_id: patients, state: "in_wait").paginate(page: params[:page], per_page: 4)
  end

  def destroy_notification
    notification = Notification.find(params[:id])
    if notification.destroy
       redirect_to notificaciones_path, notice: 'Notificación eliminada'
    else
      redirect_to notificaciones_path, notice: 'No se pudo eliminar la notificación'
    end
  end
  
  def create_notification
    user_id = params[:user_id]
    mensaje = params[:mensaje]
    fecha_citada = params[:fecha_citada]
    asunto = params[:asunto]
    titulo = params[:titulo]
    user = User.find(user_id)
    number_of_citas_in_wait = MedicalHistory.list_in_wait.count
    number_of_notifications = Notification.where(user_id: 1).count

    if mensaje == '' && fecha_citada == ''
      redirect_to lista_pacientes_en_espera_path, notice: 'No se pudo enviar la notificacion. Campos sin llenar.!!'
    else
      notification = Notification.new(user_id: user_id,titulo: titulo, mensaje: mensaje, fecha_citada: fecha_citada)
      medical_history = MedicalHistory.where(user_id: user_id, state: "in_wait").first
      if asunto
        if asunto == "1"
          medical_history.reject
        elsif asunto == "2"
          medical_history.accept
        end
        if notification.save and medical_history.save
          redirect_to lista_pacientes_en_espera_path, notice: 'Notificacion enviada!!'
        else
          redirect_to lista_pacientes_en_espera_path, notice: 'No se pudo enviar la notificacion'
        end
      else
        if notification.save
          redirect_to lista_pacientes_en_espera_path, notice: 'Notificacion enviada!!'
        else
          redirect_to lista_pacientes_en_espera_path, notice: 'No se pudo enviar la notificacion'
        end
      end
      if number_of_citas_in_wait == number_of_notifications 
        notification = Notification.where(user_id: 1).first  
        notification.destroy
      end
    end
  end

  private  
    def set_notifications_count
      @notifications_count = Notification.for_user(current_user).count
    end

    def set_enable_navigation
    @enable_navigation = true
    end

    def set_fondo_all_page
      @fondo_all_page = true
    end
end

#rails g channel notifications
#
#