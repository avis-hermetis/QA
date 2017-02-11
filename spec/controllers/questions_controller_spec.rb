require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 2) }

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

  describe "GET #show" do

    before do
      get :show, params: {id: question}
    end
    it "assigns the requested question from db to the variable @question" do
      expect(assigns(:question)).to eq(question)
    end

    it "renders show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    sign_in_user

    before do
      get :new
    end

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    sign_in_user

    context "with valid attributes" do
      it "saves new question in the db" do
        expect{ post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it "redirects to show view" do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "fails to save new question to the db" do
        expect{ post :create, params: {question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end
      it "re-renders new view" do
        post :create, params: {question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end


end
