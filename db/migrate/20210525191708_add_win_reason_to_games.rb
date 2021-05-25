class AddWinReasonToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :win_reason, :string
  end
end
