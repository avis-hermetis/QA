class ChangeQuestionsRating < ActiveRecord::Migration[5.0]
  def change
    change_column :questions, :rating, :integer, default: 0
  end
end
