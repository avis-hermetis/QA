class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  include Attachable
  include Votable

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def vote(direction, user)
    transaction do
      if vote = votes.find_by(user_id: user.id)
        if direction == :up && vote.vote == -1
          icrement!(:rating, by = 1)
          respond_with(vote.destroy location: vote.votable)
        elsif direction == :up && vote.vote == 1
          decrement!(:rating, by = 1)
          respond_with(vote.destroy location: vote.votable)
        end
      else
        if direction == :up
          increment!(:rating, by = 1)
          votes.create(user_id: user.id, value: 1)
          respond_with(votes.last, location: votes.last.votable)
        elsif direction == :down
          decrement!(:rating, by = 1)
          votes.create(user_id: user.id, value: -1)
          respond_with(votes.last, location: votes.last.votable)
        end
      end
    end
  end

  def vote_of(user)
    if vote = votes.find_by(user_id: user.id)
      if vote.value == 1
        return :up_vote
      elsif vote.value == -1
        return :down_vote
      end
    else
      return :no_vote
    end
  end

end
