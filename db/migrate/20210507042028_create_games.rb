class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.boolean :has_started
      t.string :queen_id
      t.string :chancellor_id
      t.integer :remaining_republic_policy_count
      t.integer :remaining_separatist_policy_count
      t.integer :enacted_republic_policy_count
      t.integer :enacted_separatist_policy_count
      t.string :appointed_chancellor_id
      t.integer :turn_number

      t.timestamps
    end
  end
end
