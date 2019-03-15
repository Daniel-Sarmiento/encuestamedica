class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.boolean :visto, default: false
      t.text :mensaje

      t.timestamps
    end
  end
end
