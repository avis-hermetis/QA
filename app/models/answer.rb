class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(best: :desc, created_at: :asc) }

  def check_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end