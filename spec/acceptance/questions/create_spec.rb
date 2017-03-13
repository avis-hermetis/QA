require 'acceptance/acceptance_helper'

feature "Authenticated user creates questions", %q{
  In order to share tmy problem with the community
  As authenticated user
  I want to create a questions
} do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario "Not authenticated user tries to create questions" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end

  context "Authenticated user" do

    scenario "creates question with valid attributes" do
      log_in(user)
      visit questions_path
      click_on "Ask question"
      fill_in "Title", with: "questions title"
      fill_in "Body", with: "some text"
      click_on "Create"

      expect(page).to have_content "Your question have been successfully created."
      expect(page).to have_content "some text"
      expect(current_path).to eq question_path(Question.last.id)
    end

    scenario "tries to create question with blank body" do
      log_in(user)
      click_on "Ask question"
      fill_in "Title", with: "questions title"
      fill_in "Body", with: ""
      click_on "Create"

      expect(page).to_not have_content "Your questions have been successfully created."
      expect(page).to have_content "Body can't be blank"
      expect(current_path).to eq questions_path
    end

    scenario "tries to create question with blank title" do
      log_in(user)
      click_on "Ask question"
      fill_in "Title", with: ""
      fill_in "Body", with: "some text"
      click_on "Create"

      expect(page).to_not have_content "Your questions have been successfully created."
      expect(page).to have_content "Title can't be blank"
      expect(current_path).to eq questions_path
    end

  end



end