require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many :questions}
  it {should have_many :answers}

  describe "author_of" do
    let(:user1) {create(:user)}
    let(:user2) {create(:user)}
    let(:answer) {create(:answer, user: user1)}

    it "true if user is the author of object" do
      expect(user1).to be_author_of(answer)
    end

    it "false if user is not the author of object" do
      expect(user2).to_not be_author_of(answer)
    end
  end
end
