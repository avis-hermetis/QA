class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  include Attachable
  include Votable

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
