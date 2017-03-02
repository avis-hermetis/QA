class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def check_best
    self.transaction do
      Answer.update_all(best: false)
      self.update!(best: true)
    end
  end

  def best?
    self.best
  end
end