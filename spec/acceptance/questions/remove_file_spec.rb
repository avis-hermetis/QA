require 'acceptance/acceptance_helper'

feature "Authenticated user deletes attached files", %q{
  In order to dispode of the attached file
  As an authenticated user
  I want to be able to delete my detached file
} do
  given(:user) {create(:user)}
  given(:file) {create(:attachment)}
  given!(:question) {create(:question, attachments: [file])}
  scenario 'Not authenticated user does not see the delete file button', js: true do
    visit question_path(question)

    expect(page).to have_content file.file.filename
    expect(page).to_not have_content "Delete file"
  end

  context "NOT the author of question " do

    scenario " fails to delete attached file", js: true do
      log_in(user)

      visit question_path(question)
      expect(page).to have_content file.file.filename
      expect(page).to_not have_content "Delete file"
    end
  end

  context "Author of question" do
    given!(:question) {create(:question, user: user, attachments: [file])}

    scenario "deletes his attached file", js: true do
      log_in(user)

      visit question_path(question)
      expect(page).to have_content file.file.filename

      click_on "Delete file"

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content file.file.filename
    end
  end
end