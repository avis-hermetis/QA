require 'rails_helper'

feature "Unregistered user sign up", %q{
  In order to ask questions
  As unregistered user
  I want to sign up
} do

  scenario "User tries to sign up with valid params" do
    visit new_user_registration_path

    fill_in "Email", with: "new@test.com"
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end
  scenario "User tries to sign up with blank email" do
    visit new_user_registration_path
    fill_in "Email", with: ""
    fill_in "Password", with: "12345678"
    fill_in "Password confirmation", with: "12345678"
    click_on "Sign up"

    expect(page).to have_content "Email can't be blank"
    expect(current_path).to eq "/users"
  end

  scenario "User tries to sign up with other user's email" do
    user = create(:user)
    visit new_user_registration_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_on "Sign up"

    expect(page).to have_content "Email has already been taken"
    expect(current_path).to eq "/users"
  end
end