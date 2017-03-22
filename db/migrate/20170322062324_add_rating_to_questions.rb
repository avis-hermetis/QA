class AddRatingToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :rating, :integer
  end
end
