class AddStatsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :total_games_as_sith, :integer
    add_column :users, :total_games_as_senator, :integer
    add_column :users, :total_games_as_palpatine, :integer
    add_column :users, :wins_as_sith, :integer
    add_column :users, :losses_as_sith, :integer
    add_column :users, :wins_as_senator, :integer
    add_column :users, :losses_as_senator, :integer
    add_column :users, :wins_as_palpatine, :integer
    add_column :users, :losses_as_palpatine, :integer
  end
end
