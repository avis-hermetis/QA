require 'rails_helper'

feature "Authenticated user creates question", %q{
  In order to share tmy problem with the community
  As authenticated user
  I want to create a question
} do
  scenario "Authenticated user creates question" do
    User.create!(email: "user@test.com", password: "12345678")

    visit new_user_session_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    click_on "Ask question"

    fill_in "Title", with: "question title"
    fill_in "Body", with: "some text"
    click_on "Create"

    expect(page).to have_content "Your question have been successfully created."
    expect(page).to have_content "some text"
    expect(current_path).to eq question_path(Question.last.id)

  end
  scenario "Not authenticated user creates question" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end