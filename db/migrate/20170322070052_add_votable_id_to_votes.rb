class AddVotableIdToVotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :votes, :votable

    add_column :votes, :votable_type, :string
    add_index :votes, :votable_type
  end
end
