class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers
  has_many :votes

  def author_of?(obj)
    id == obj.user_id
  end

  def voted_for?(obj)
    obj.votes.each do |v|
      if v.id == id
        return v
      else
        return nil
      end
    end
  end
end