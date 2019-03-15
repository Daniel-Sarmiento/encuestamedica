class AddColumnsToMedicalHistories < ActiveRecord::Migration[5.1]
  def change
  	add_column :medical_histories, :fecha_citada, :datetime
  	add_column :medical_histories, :respuestas_parte_uno, :text
  	add_column :medical_histories, :respuestas_parte_dos, :text
  	add_column :notifications, :fecha_citada, :datetime
  end
end
