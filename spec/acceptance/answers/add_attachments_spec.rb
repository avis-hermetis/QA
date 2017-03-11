require 'acceptance/acceptance_helper'

feature "Authenticated user creates answers with attachments", %q{
  In order to help to illustrate my answer
  As an authenticated user
  I want to be able to attach file
} do
  given(:user) {create(:user)}
  given(:question) {create(:question, user:user)}
  context "Authenticated user" do
    background do
      log_in user
      visit question_path(question)
    end
    scenario "attaches file to answer", js: true do
      fill_in "Text", with: "some text"
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on "Answer it"

      within '.answer' do
        expect(page).to have_content 'rails_helper.rb'
      end
    end
  end
end