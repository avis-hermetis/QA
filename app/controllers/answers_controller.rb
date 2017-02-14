class AnswersController < ApplicationController
  before_action :set_question, only:[:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    redirect_to @question
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      @notice = "Your answer have been successfully deleted."
    else
      @notice = "Other user's answer can't be deleted."
    end
    redirect_to @answer.question, notice: @notice
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
