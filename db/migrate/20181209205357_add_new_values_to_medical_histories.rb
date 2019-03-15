class AddNewValuesToMedicalHistories < ActiveRecord::Migration[5.1]
  def change
    add_reference :medical_histories, :user, foreign_key: true
  end
end
