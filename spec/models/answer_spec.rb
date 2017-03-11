require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to :question}
  it {should belong_to :user}
  it {should have_many :attachments}

  it {should have_db_column(:question_id).with_options(foreign_key: true)}
  it {should have_db_column(:user_id).with_options(foreign_key: true)}

  it {should validate_presence_of :body}

  it {should accept_nested_attributes_for :attachments}

  describe 'check_best' do
    let!(:question) {create(:question)}
    let!(:answer) {create(:answer, question: question)}
    let!(:other_answers) {create_list(:answer, 2, question: question, best: true)}

    it 'changes attribute best from false to true' do
      expect{answer.check_best}.to change(answer, :best).from(false).to(true)
    end

    it 'sets all other objects attributes best to false' do
      answer.check_best
      other_answers.each do |o_answer|
        expect(o_answer.reload).to_not be_best
      end
    end
  end
end
