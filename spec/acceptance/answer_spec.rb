require 'rails_helper'

feature "Authenticated user creates answer", %q{
  In order to help user with his problem
  As an authenticated user
  I want to be able to create answer
} do
    given(:question) {create(:question)}

    scenario "Not authenticated user tries to create answer" do
      visit question_path(question)

      fill_in "Body", with: "some answer"
      click_on "Answer it"

      expect(page).to_not have_content "some answer"
      expect(current_path).to eq question_answers_path(question)
    end

    context "Authenticated user" do
      given(:user) {create(:user)}

      scenario "creates answer" do
        log_in(user)

        visit question_path(question)

        fill_in "Body", with: "some answer"
        click_on "Answer it"

        expect(page).to have_content "some answer"
        expect(current_path).to eq question_path(question)
      end
    end

 end

  feature "Authenticated user deletes answer", %q{
  In order to dispode of the wrong answer
  As an authenticated user
  I want to be able to delete my answer
} do
    given!(:answer) {create(:answer)}

    scenario "Guest tries to delete any answer" do
      visit question_path(answer.question)

      expect(page).to have_content answer.body
      expect(page).to_not have_content "Log out"
      expect(page).to_not have_content "Delete"
    end

    context "Authenticated user " do
      given(:user) {create(:user)}

      scenario " tries to delete OTHER USER'S answer" do
        log_in(user)

        visit question_path(answer.question)
        expect(page).to have_content answer.body
        expect(page).to_not have_content "Delete"
      end
    end

    context "Authenticated user" do
      given(:user) {create(:user)}
      given!(:answer) {create(:answer, user: user)}

      scenario "deletes HIS answer" do
        log_in(user)

        visit question_path(answer.question)
        expect(page).to have_content answer.body

        click_on "Delete"
        save_and_open_page
        expect(page).to have_content "Your answer have been successfully deleted."
        expect(current_path).to eq question_path(answer.question)
        expect(page).to_not have_content answer.body
      end
    end
end