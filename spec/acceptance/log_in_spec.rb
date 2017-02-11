require 'rails_helper'

feature "User log in", %q{
  In order to ask question
  As a user
  I want to log in
} do
  scenario "Registered user tries to log in" do
    User.create!(email: "user@test.com", password: "12345678")

    visit new_user_session_path
    fill_in "Email", with: "user@test.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end
  scenario "Not registered user tries to log in" do
    visit new_user_session_path
    fill_in "Email", with: "invalid@test.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    expect(page).to have_content "Invalid Email or password. Log in Email Password Remember
    me Sign up Forgot your password?"
    expect(current_path).to eq new_user_session_path
  end
end