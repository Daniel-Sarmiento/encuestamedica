class CreateLifestyles < ActiveRecord::Migration[5.1]
  def change
    create_table :lifestyles do |t|

      t.timestamps
    end
  end
end
