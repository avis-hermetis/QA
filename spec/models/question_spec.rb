require 'spec_helper'

RSpec.describe Question, type: :model do
  it {should have_many(:answers).dependent(:destroy)}
  it {should belong_to :user}
  it {should have_many :attachments}

  it {should have_db_column(:user_id).with_options(foreign_key: true)}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}

  it {should accept_nested_attributes_for :attachments}

  describe "vote" do
    let!(:user) {create(:user)}
    let!(:question) {create(:question)}

    it 'increments rating and creates new vote object' do
      expect{question.vote(:up, user)}.to change(question, :rating).by(1)
    end
    it 'decrements rating' do
      expect{question.vote(:down, user)}.to change {question.rating}.by(-1)
    end
    it 'creates new vote instance' do
      expect{question.vote(:up, user)}.to change(Vote, :count).by(1)
    end
    it 'deletes existed vote instance' do
      question.votes.create(user: user, value: 1)
      expect{question.vote(:down, user)}.to change(Vote, :count).by(-1)
    end
  end

end