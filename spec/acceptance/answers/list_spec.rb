require 'rails_helper'

feature "User see the list of answers of a particular question ", %q{
  In order to choose answers
  As a user
  I want to see answers list
} do
  given(:question) {create(:question)}
  given!(:answers) {create_list(:answer, 5, question: question)}
  scenario "User see answers list"do

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
    expect(page).to have_content answers[2].body
    expect(page).to have_content answers[3].body
    expect(page).to have_content answers[4].body

  end
end