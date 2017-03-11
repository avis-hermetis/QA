require 'acceptance/acceptance_helper'

feature "Authenticated user creates answers with attachments", %q{
  In order to help to illustrate my answer
  As an authenticated user
  I want to be able to attach file
} do
  given(:user) {create(:user)}

  context "Authenticated user" do
    background do
      log_in user
      visit new_question_path
    end
    scenario "attaches file to answer", js: true do
      fill_in "Title", with: "questions title"
      fill_in "Body", with: "some text"
      click_on "Create"
      add_file 'File', with: "#{Rails.root}/spec/spec_helper.rb"

      expect(page).to have_link
    end
  end
end