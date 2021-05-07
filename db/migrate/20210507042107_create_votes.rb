class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.string :player_id
      t.string :game_id
      t.integer :turn_number
      t.boolean :in_favor

      t.timestamps
    end
  end
end
