require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }


  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes do' do

      it 'sets user_id equal to the curent user' do
         post :create, params: {question_id: question, answer: attributes_for(:answer)}
         expect(assigns(:answer).user).to eq @user
      end

      it 'saves the new answers to the database' do
        expect{ post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question
      end

    end

    context 'with invalid attributes' do

      it 'does not save the questions to the database' do
        expect{ post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)} }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_question)}
        expect(response).to redirect_to question
      end

    end
  end

  describe "DELETE #destroy" do

    context "User is the author of answer" do
      sign_in_user
      let!(:answer) { create(:answer, user: @user) }

      it "deletes requested answers from the db" do
        expect{delete :destroy, params: {id: answer}}.to change(Answer, :count).by(-1)
      end
      it "redirects to questions show view" do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context "User is NOT the author  answer" do
      sign_in_user
      let!(:answer) { create(:answer) }

      it "failes to delete requested answers from the db" do
        expect{delete :destroy, params: {id: answer}}.to change(Answer, :count).by(0)
      end
      it "redirects to questions show view" do
        delete :destroy, params: {id: answer}
        expect(response).to redirect_to question_path(answer.question)
      end
    end

  end
end

