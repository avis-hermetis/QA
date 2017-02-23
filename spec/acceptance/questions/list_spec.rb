require 'acceptance/acceptance_helper'

feature "User see the list of questions", %q{
  In order to choose questions
  As a user
  I want to see questions list
} do
  given!(:question_list) {create_list(:question, 5)}

  scenario "User see questions list"do

    visit questions_path

    question_list.each do |q|
      expect(page).to have_content q.title
    end
  end
end