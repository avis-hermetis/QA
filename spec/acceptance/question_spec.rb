require 'rails_helper'

feature "Authenticated user creates question", %q{
  In order to share tmy problem with the community
  As authenticated user
  I want to create a question
} do
  given(:user) {create(:user)}

  scenario "Authenticated user creates question" do
    log_in(user)

    click_on "Ask question"

    fill_in "Title", with: "question title"
    fill_in "Body", with: "some text"
    click_on "Create"

    expect(page).to have_content "Your question have been successfully created."
    expect(page).to have_content "some text"
    expect(current_path).to eq question_path(Question.last.id)

  end
  scenario "Not authenticated user tries to create question" do
    visit questions_path
    click_on "Ask question"

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end

feature "User see the list of questions", %q{
  In order to choose question
  As a user
  I want to see questions list
} do
  given!(:question_list) {create_list(:question, 2)}

  scenario "User see questions list"do

    visit questions_path

    expect(page).to have_content question_list[0].title
    expect(page).to have_content question_list[1].title
  end
end

feature "User deletes his question", %q{
  In order to delete his question
  As an authenticated user
  I want to be able to delete my question
} do
  scenario "Authenticated user deletes HIS question" do
    given(:user) {create(:user)}
    given(:question) {create(:question, user: user)}

    log_in(user)

    visit questions_path
    expect(page).to have_content question.title

    click_on "Delete"

    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end
  scenario "Authenticated user tries to delete OTHER USER'S question" do
    given(:question) {create(:question)}
    given(:user) {create(:user)}

    log_in(user)

    visit questions_path
    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete"
  end
  scenario "Guest tries to delete any question" do
    visit questions_path

    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete"
  end
end