class AddLastPoliticiansToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :last_queen, :string
    add_column :games, :next_queen, :string
    add_column :games, :last_chancellor, :string
  end
end
