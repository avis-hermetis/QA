require 'rails_helper'

feature "Authenticated user creates answers", %q{
  In order to help user with his problem
  As an authenticated user
  I want to be able to create answers
} do
  given(:question) {create(:question)}
  given(:user) {create(:user)}

  scenario "Not authenticated user tries to create answers", js: true do
    visit question_path(question)

    fill_in "Body", with: "some answer"
    click_on "Answer it"

    within '.answers' do
      expect(page).to_not have_content "some answer"
      expect(current_path).to eq question_path(question)
    end

  end

  context "Authenticated user" do

    scenario "creates answers with valid attributes", js: true do
      log_in(user)
      visit question_path(question)
      fill_in "Body", with: "some answer"
      click_on "Answer it"

      within '.answers' do
        expect(page).to have_content "some answer"
      end
      expect(current_path).to eq question_path(question)
    end

  end
end
