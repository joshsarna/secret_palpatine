class AddFailedElectionCountToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :failed_election_count, :integer
  end
end
