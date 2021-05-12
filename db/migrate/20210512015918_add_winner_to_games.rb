class AddWinnerToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :winner, :string
  end
end
