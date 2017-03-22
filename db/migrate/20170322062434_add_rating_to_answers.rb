class AddRatingToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :rating, :integer
  end
end
