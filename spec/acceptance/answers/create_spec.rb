require 'rails_helper'

feature "Authenticated user creates answers", %q{
  In order to help user with his problem
  As an authenticated user
  I want to be able to create answers
} do
  given(:question) {create(:question)}
  given(:user) {create(:user)}

  scenario "Not authenticated user tries to create answers" do
    visit question_path(question)

    fill_in "Body", with: "some answers"
    click_on "Answer it"

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path

  end

  context "Authenticated user" do

    scenario "creates answers with valid attributes" do
      log_in(user)
      visit question_path(question)
      fill_in "Body", with: "some answers"
      click_on "Answer it"

      expect(page).to have_content "some answers"
      expect(current_path).to eq question_path(question)
    end

    scenario "tries to create answers with invalid attributes" do
      log_in(user)
      visit question_path(question)
      fill_in "Body", with: ""
      click_on "Answer it"

      expect(page).to have_content "Body can't be blank"
      expect(current_path).to eq question_answers_path(question)
    end

  end
end
