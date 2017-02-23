require 'acceptance/acceptance_helper'

feature "Authenticated user updates answer", %q{
  In order to change my answer
  As an authenticated user
  I want to be able to update the answer
} do
  let(:user) {create(:user)}
  let(:question) {create(:question)}
  let(:answer) {create(:answer, user: user, question: question)}

  scenario "Not authenticated user does not see the Edit' button" do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit'
    end
  end

  context "Authenticated user, author of answer" do
    before do
      log_in(user)
      visit question_path(question)
    end

    scenario "edits his answer with valid attributes" do
      fill_in "Text", with: "edited answer"
      click_on "Edit"

      within '.answers' do
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'answer-edit-form'
      end
    end

    scenario "failes to edit his answer with invalid attribute" do
      within '.answers' do
        click_on "Edit"

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'answer-edit-form'
      end
    end
  end

  context "Authenticated user, other then the author of answer"do
    let(:other_user) {create(:user)}
    let(:answer) {create(:answer, user: other_user, question: question)}

    scenario "failes to edit the answer" do


      log_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to_not have_link 'Edit'
      end
    end
  end

end