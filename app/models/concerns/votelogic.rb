module Votelogic
  extend ActiveSupport::Concern

  included do

    def vote(direction, user)
      transaction do
        if vote = votes.find_by(user_id: user.id)
          if direction == :up && vote.value == -1
            increment!(:rating, by = 1)
            vote.destroy && vote.value
          elsif direction == :down && vote.value == 1
            decrement!(:rating, by = 1)
            vote.destroy && vote.value
          end
        else
          if direction == :up
            increment!(:rating, by = 1)
            votes.create(user_id: user.id, value: 1) && 0
          elsif direction == :down
            decrement!(:rating, by = 1)
            votes.create(user_id: user.id, value: -1) && 0
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

end