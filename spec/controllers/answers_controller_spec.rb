require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }


  describe 'POST #create' do

    it 'Unauthenticated user get response with unathorized(401) status' do
      post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
      expect(response).to have_http_status(401)
    end

    context 'with valid attributes do' do
      sign_in_user

      it 'sets user_id equal to the curent user' do
         post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
         expect(assigns(:answer).user).to eq @user
      end

      it 'saves the new answers to the database' do
        expect{ post :create, params: {question_id: question, answer: attributes_for(:answer)}, format: :js }.to change(question.answers, :count).by(1)
      end
      it 'render create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      it 'does not save the questions to the database' do
        expect{ post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}, format: :js }.to_not change(Answer, :count)
      end

      it 'renders question show view' do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer), format: :js}
        expect(response).to render_template 'answers/create'
      end
    end
  end

  describe "DELETE #destroy" do

    context "User is the author of answer" do
      sign_in_user
      let!(:answer) { create(:answer, user: @user) }

      it "deletes requested answers from the db" do
        expect{delete :destroy, params: {id: answer}, format: :js}.to change(Answer, :count).by(-1)
      end
      it "render destroy template " do
        delete :destroy, params: {id: answer, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context "User is NOT the author  answer" do
      sign_in_user
      let!(:answer) { create(:answer) }

      it "failes to delete requested answers from the db" do
        expect{delete :destroy, params: {id: answer}, format: :js}.to_not change(Answer, :count)
      end
    end

  end

  describe "PATCH #update" do

    context "User is the author of answer" do
      sign_in_user
      let!(:answer) { create(:answer, user: @user, question: question) }

      it "assigns requested answer to the @answer variable" do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
        expect(assigns(:answer)).to eq answer
      end
      it "changes answer attributes" do
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new body'}, format: :js}
        answer.reload
        expect(answer.body).to eq 'new body'
      end
      it "failes to change answer with invalid attributes" do
        patch :update, params: {id: answer, question_id: question, answer: {body: ''}, format: :js}
        answer.reload
        expect(answer.body).to_not eq ''
      end
      it "render update template" do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :update
      end
    end

    context "User is NOT the author of answer" do
      sign_in_user
      let!(:answer) { create(:answer, question: question) }

      it "failes to change answer attributes" do
        patch :update, params: {id: answer, question_id: question, answer: {body: 'new body'}, format: :js}
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it "render update template" do
        patch :update, params: {id: answer, question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :update
      end
    end

  end

  describe 'PATCH #check_best' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    before do
      sign_in answer.question.user
    end

    it "assigns requested answer to the @answer variable" do
        patch :check_best, params: {id: answer}, format: :js
        expect(assigns(:answer)).to eq answer
    end

    it "set answer as best" do
      patch :check_best, params: {id: answer}, format: :js
      answer.reload
      expect(answer).to  be_best
    end

    it "renders check_best  template" do
      patch :check_best, params: {id: answer}, format: :js
      expect(response).to render_template :check_best
    end
  end
end

