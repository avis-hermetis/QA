require 'rails_helper'

feature "User log out", %q{
 In order to close my session
 As a signed in user
 I want to log out
} do
    given(:user) {create(:user)}
    scenario do
        log_in(user)
        save_and_open_page
        click_on "Log out"

        except(current_path).to eq questions_path
        except(page).to have_content "You have successfully log out"
        except(page).to have_content "Log in"
        except(page).to_not have_content "Log in"
    end
end