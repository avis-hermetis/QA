class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  include Attachable
  include Votable

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(best: :desc, created_at: :asc) }

  def check_best
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

end