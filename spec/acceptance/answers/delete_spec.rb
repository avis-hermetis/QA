require 'rails_helper'

feature "Authenticated user deletes answers", %q{
  In order to dispode of the wrong answers
  As an authenticated user
  I want to be able to delete my answers
} do
  given!(:answer) {create(:answer)}
  given(:user) {create(:user)}

  scenario 'Not authenticated user tries to delete answer'do
    visit question_path(answer.question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content "Delete"
  end

  context "Other user " do

    scenario " tries to delete answer" do
      log_in(user)

      visit question_path(answer.question)
      expect(page).to have_content answer.body
      expect(page).to_not have_content "Delete"
    end
  end

  context "Author of answer" do
    given!(:answer) {create(:answer, user: user)}

    scenario "deletes his answer" do
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