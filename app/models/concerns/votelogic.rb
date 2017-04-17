module Votelogic
  extend ActiveSupport::Concern

  included do

    def vote(direction, user)
      transaction do
        if vote = find_vote_by(user)
          change_vote(direction, vote)
        else
          create_vote(direction)
        end
      end

    end

    def create_vote(direction)
      if direction == :up
        increment!(:rating, by = 1)
        votes.create(user_id: user.id, value: 1) && 0
      elsif direction == :down
        decrement!(:rating, by = 1)
        votes.create(user_id: user.id, value: -1) && 0
      end
    end

    def change_vote(direction, vote)
      if direction == :up && vote.value == -1
        increment!(:rating, by = 1)
        vote.destroy && vote.value
      elsif direction == :down && vote.value == 1
        decrement!(:rating, by = 1)
        vote.destroy && vote.value
      end
    end

    def find_vote_by(user)
      votes.find_by(user_id: user.id)
    end

    def vote_value(user)
      vote = find_vote_by(user) if user.present?
      vote.value if vote.present?
    end

  end

end