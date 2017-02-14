require 'rails_helper'

feature "User deletes his questions", %q{
  In order to delete his questions
  As an authenticated user
  I want to be able to delete my questions
} do
  given!(:question) {create(:question)}

  context "Authenticated user is NOT the author of questions" do
    given(:user) {create(:user)}

    scenario " tries to delete OTHER USER'S questions" do
      log_in(user)

      visit questions_path
      expect(page).to have_content question.title
      expect(page).to_not have_content "Delete"
    end
  end

  context "Authenticated user IS the author of questions" do
    given(:user) {create(:user)}
    given!(:question) {create(:question, user: user)}

    scenario "deletes HIS questions" do
      log_in(user)

      visit questions_path
      expect(page).to have_content question.title

      click_on "Delete"

      expect(current_path).to eq questions_path
      expect(page).to_not have_content question.title
    end
  end

end