require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many :questions}
  it {should have_many :answers}

  describe "author_of" do
    user = User.create
    answer = Answer.create(user: user)

    it "compares user id with the object's user_id with" do
      expect(user.author_of?(answer)).to eq true
    end
  end
end
