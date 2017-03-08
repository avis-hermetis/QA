class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only:[:create]
  before_action :set_answer, only: [:destroy, :update, :check_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
    else
    end
  end

  def update
    @answer.update(answer_params) if current_user&.author_of?(@answer)
  end

  def check_best
    @answer.check_best if current_user&.author_of?(@answer.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
