require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "GET #index" do
    let(:questions) { FactoryGirl.create_list(:question, 2) }

    before do
      get :index
    end

    it "populates an array with all questions from the database" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end
end
