require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 5) }

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
    it "assigns the requested questions from db to the variable @questions" do
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

    it "assigns a new Question to @questions" do
      expect(assigns(:question)).to be_a_new(Question)
    end
    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    sign_in_user

    context "with valid attributes" do
      it 'sets user_id equal to the curent user' do
        post :create, params: {question: attributes_for(:question)}
        expect(assigns(:question).user).to eq @user
      end

      it "saves new questions in the db" do
        expect{ post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it "redirects to show view" do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "fails to save new questions to the db" do
        expect{ post :create, params: {question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end
      it "re-renders new view" do
        post :create, params: {question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    context "User is the author of question" do
      sign_in_user
      let(:question) {create(:question, user: @user)}

      it "deletes requested questions from the db" do
        question
        expect{ delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
      end
      it "redirects to index view" do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context "User is NOT the author of question" do
      sign_in_user
      let(:question) {create(:question)}

      it "deletes requested questions from the db" do
        question
        expect{ delete :destroy, params: {id: question} }.to_not change(Question, :count)
      end
      it "redirects to index view" do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end
    end
  end


