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

  def vote(direction, user)
    transaction do
      if vote = votes.find_by(user_id: user.id)
        if direction == :up && vote.value == -1
          increment!(:rating, by = 1)
          vote.destroy && rating
        elsif direction == :down && vote.value == 1
          decrement!(:rating, by = 1)
          vote.destroy && rating
        end
      else
        if direction == :up
          increment!(:rating, by = 1)
          votes.create(user_id: user.id, value: 1) && rating
        elsif direction == :down
          decrement!(:rating, by = 1)
          votes.create(user_id: user.id, value: -1) && rating
        end
      end
    end
  end

  def vote_of(user)
    if vote = votes.find_by(user_id: user.id)
      if vote.value == 1
        :up_vote
      elsif vote.value == -1
        :down_vote
      end
    else
      :no_vote
    end
  end
end