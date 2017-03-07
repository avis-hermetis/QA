class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only:[:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.try(:author_of?, @answer)
      @answer.destroy
    else
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.try(:author_of?, @answer)
  end

  def check_best
    @answer = Answer.find(params[:id])
    @answer.check_best if current_user.try(:author_of?, @answer.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
