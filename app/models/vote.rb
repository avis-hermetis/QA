class Vote < ApplicationRecord
  belongs_to :votable, polymorohic: true
end
