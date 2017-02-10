require 'rails_helper'

feature "User log in", %q{
  In order to ask question
  As a user
  I want to log in
} do
  scenario "Registered user tries to log in" do
    User.create!(email: "user@test.com", password: "12345678")

    click_on new_user_session_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"
    save_and_open_page

    expect(page).to have_content "Logged in successfully."
    expect(current_path).to eq root_path
  end
  scenario "Not registered user tries to log in" do
    click_on new_user_session_path
    fill_in "Email", with: "invalid@test.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    expect(page).to have_content "Invalid email or password."
    expect(current_path).to eq new_user_session_path
  end
end