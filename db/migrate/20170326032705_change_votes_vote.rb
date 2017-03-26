class ChangeVotesVote < ActiveRecord::Migration[5.0]
  def change
    rename_column :votes, :vote, :value
  end
end
