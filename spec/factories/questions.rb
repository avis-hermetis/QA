FactoryGirl.define do
  sequence :title do |n|
    title "MyString#{n}"
  end
  factory :question do
    title "MyString"
    body "MyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
