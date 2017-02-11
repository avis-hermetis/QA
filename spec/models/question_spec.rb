require 'spec_helper'

RSpec.describe Question, type: :model do
  it {should have_many(:answers).dependent(:destroy)}
  it {should belong_to :user}
  it {should have_db_column(:user_id).with_options(foreign_key: true)}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
end
