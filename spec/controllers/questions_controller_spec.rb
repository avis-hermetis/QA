require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { FactoryGirl.create(:question) }

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

  describe "GET #edit" do

    before do
      get :edit, params: {id: question}
    end

    it "assigns the requested question from db to the variable @question" do
      expect(assigns(:question)).to eq(question)
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new question in the db" do
        expect{ post :create, params: {question: FactoryGirl.attributes_for(:question)} }.to change(Question, :count).by(1)
      end
      it "redirects to show view" do
        post :create, params: {question: FactoryGirl.attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "fails to save new question to the db" do
        expect{ post :create, params: {question: FactoryGirl.attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end
      it "re-renders new view" do
        post :create, params: {question: FactoryGirl.attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do

      it "assigns the requested question to @question" do
        patch :update, params: {id: question, question: FactoryGirl.attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it "saves question with new params in the db" do
        patch :update, params: {id: question, question: {title: "new title", body: "new body"} }
        question.reload
        expect(question.title).to eq "new title"
        expect(question.body).to eq "new body"
      end
      it "redirects to show view of updated question" do
        patch :update, params: {id: question, question: FactoryGirl.attributes_for(:question)}
        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes" do
      before { patch :update, params: {id: question, question: {title: "new title", body: nil}} }
      it "fails to save question with invalid params " do
        question.reload
        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end
      it "re-renders edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the question" do
      question
      expect { delete :destroy, params: {id: question} }.to change(Question, :count).by(-1)
    end
    it "redirects to index view" do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end
end
