require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many :questions}
  it {should have_many :answers}

  describe "author_of" do
    user2 = User.create(email: "2@test.com", password: "12345678", password_confirmation: "12345678")
    user1 = User.create(email: "1@test.com", password: "23456789", password_confirmation: "23456789")
    answer_user1 = Answer.create(user: user1)

    it "true if user is the author of object" do
      expect(user1.author_of?(answer_user1)).to eq true
    end

    it "false if user is not the author of object" do
      expect(user2.author_of?(answer_user1)).to eq false
    end
  end
end
