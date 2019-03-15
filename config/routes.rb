Rails.application.routes.draw do
  devise_for :users

  root 'welcome#notifications_list'
  get '/historiales', to: 'welcome#patients_list', as: 'lista_pacientes'
  get '/lista_pacientes_en_espera', to: 'welcome#patient_list_in_wait', as: 'lista_pacientes_en_espera'
  get '/search/create', to: 'welcome#search'
  get '/search/patients', to: 'welcome#search_in_medical_history'
  get '/mi_cita', to: 'welcome#my_date', as: 'mi_cita'
  get '/mis_citas', to: 'welcome#my_appointments', as: 'mis_citas'
  resources :medical_histories
  post '/historiaMedica', to: 'welcome#update_history', as: 'actulizar_historia_medica'
  post '/notification/new', to: 'welcome#create_notification', as: 'create_notification'
  delete '/notification/:id' => 'welcome#destroy_notification', as: 'notificaciones_destroy'
  get '/notificaciones', to: 'welcome#notifications_list', as: 'notificaciones'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #get '/solicitar_cita', to: 'welcome#request_medical-history', as: 'solicitar_cita'
end
