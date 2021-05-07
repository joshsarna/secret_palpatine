class AddCurrentHandPolicyCountsToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :current_hand_republic_policy_count, :integer
    add_column :games, :current_hand_separatist_policy_count, :integer
  end
end
