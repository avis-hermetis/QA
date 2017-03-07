require 'acceptance/acceptance_helper'

feature "Authenticated user updates question", %q{
  In order to change my question
  As an authenticated user
  I want to be able to update the question
} do
  given(:user) {create(:user)}
  given!(:question) {create(:question, user: user)}

  scenario "Not authenticated user does not see the Edit button and form", js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_selector 'textarea#question_form'

  end

  context 'Authenticated user, author of question, ' do
    scenario "- to edit his question with valid attribute", js: true do
      log_in(user)
      visit question_path(question)
      within "#question-#{question.id}" do
        click_on 'Edit'
        expect(page).to_not have_link 'Edit'
        expect(page).to have_selector 'textarea#question_body'
        fill_in "Title", with: "new title"
        fill_in "Body", with: "new body"
        click_on "Update"

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "fails to edit question with invalid title", js: true do
      log_in(user)
      visit question_path(question)

      within "#question-#{question.id}" do
        click_on 'Edit'
        expect(page).to_not have_link 'Edit'
        expect(page).to have_selector 'textarea#question_body'
        fill_in 'Body', with: "new body"
        click_on "Update"

        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end


    scenario "fails to edit question with invalid body", js: true do
      log_in(user)
      visit question_path(question)

      within "#question-#{question.id}" do
        click_on 'Edit'
        expect(page).to_not have_link 'Edit'
        expect(page).to have_selector 'textarea#question_body'
        fill_in "Title", with: "new title"
        click_on "Update"

        expect(page).to have_content 'new title'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  context 'Authenticated user, NOT the author of question,' do
    given!(:other_user) {create(:user)}
    scenario " does not see the Edit button and form", js: true do
      log_in(other_user)
      visit question_path(question)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
      expect(page).to_not have_selector 'textarea#question_form'
    end
  end

end