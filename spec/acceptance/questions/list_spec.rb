require 'rails_helper'

feature "User see the list of questions", %q{
  In order to choose questions
  As a user
  I want to see questions list
} do
  given!(:question_list) {create_list(:question, 5)}

  scenario "User see questions list"do

    visit questions_path

    expect(page).to have_content question_list[0].title
    expect(page).to have_content question_list[1].title
    expect(page).to have_content question_list[2].title
    expect(page).to have_content question_list[3].title
    expect(page).to have_content question_list[4].title
  end
end