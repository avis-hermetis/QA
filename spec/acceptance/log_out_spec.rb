require 'rails_helper'

feature "User log out", %q{
 In order to close my session
 As a signed in user
 I want to log out
} do
    given(:user) {create(:user)}
    scenario do
      log_in(user)
      click_on "Log out"

      expect(page).to have_content "Signed out successfully."
      expect(page).to_not have_content "Log out"
      expect(page).to have_content "Sign up"
      expect(current_path).to eq root_path
    end
end