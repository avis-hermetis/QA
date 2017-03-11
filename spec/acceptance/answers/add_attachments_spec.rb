require 'acceptance/acceptance_helper'

feature "Authenticated user creates answers with attachments", %q{
  In order to help to illustrate my answer
  As an authenticated user
  I want to be able to attach file
} do
  given(:user) {create(:user)}

  context "Authenticated user" do

    scenario "attaches file to answer", js: true do

    end
  end
end
