require 'rails_helper'

feature "Authenticated user deletes answers", %q{
  In order to dispode of the wrong answers
  As an authenticated user
  I want to be able to delete my answers
} do
  given!(:answer) {create(:answer)}
  given(:user) {create(:user)}

  context "Authenticated user " do

    scenario " tries to delete OTHER USER'S answers" do
      log_in(user)

      visit question_path(answer.question)
      expect(page).to have_content answer.body
      expect(page).to_not have_content "Delete"
    end
  end

  context "Authenticated user" do
    given!(:answer) {create(:answer, user: user)}

    scenario "deletes HIS answers" do
      log_in(user)

      visit question_path(answer.question)
      expect(page).to have_content answer.body

      click_on "Delete"

      expect(page).to have_content "Your answer have been successfully deleted."
      expect(current_path).to eq question_path(answer.question)
      expect(page).to_not have_content answer.body
    end
  end
end