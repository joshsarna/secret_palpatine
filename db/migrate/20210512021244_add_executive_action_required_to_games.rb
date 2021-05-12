class AddExecutiveActionRequiredToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :executive_action_required, :boolean
  end
end
