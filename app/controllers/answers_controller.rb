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
      head 403
    end
  end

  def update
    if current_user&.author_of?(@answer)
      @answer.update(answer_params)
    else
      head 403
    end
  end

  def check_best
    if current_user&.author_of?(@answer.question)
      @answer.check_best
    else
      head 403
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
