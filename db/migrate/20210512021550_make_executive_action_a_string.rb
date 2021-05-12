class MakeExecutiveActionAString < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :executive_action_required, :string
  end
end
