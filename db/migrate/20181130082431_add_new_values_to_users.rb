class AddNewValuesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :numero_trabajador, :string
  end
end
