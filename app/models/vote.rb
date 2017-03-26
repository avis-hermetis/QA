class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true
  validates :votable_id, presence: true
  validates :value, inclusion: {in: [-1,1]}

end
