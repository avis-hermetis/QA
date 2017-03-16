require 'acceptance/acceptance_helper'

feature "Authenticated user creates question with attachments", %q{
  In order to help to illustrate my question
  As an authenticated user
  I want to be able to attach file
} do
  given(:user) {create(:user)}

  context "Authenticated user" do
    background do
      log_in user
      visit new_question_path
    end
    scenario "attaches file to question", js: true do
      fill_in "Title", with: "questions title"
      fill_in "Body", with: "some text"

      attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
      click_on 'add file'
      page.all('.nested-fields').last.attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Create'


      expect(page).to have_link('spec_helper.rb')
      expect(page).to have_link('rails_helper.rb')
    end
  end
end