class AddUserReferenceToVotes < ActiveRecord::Migration[5.0]
  def change
    add_reference :votes, :user
  end
end
