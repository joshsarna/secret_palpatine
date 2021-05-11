class AddRemainingPoliciesToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :remaining_policies, :string
  end
end
