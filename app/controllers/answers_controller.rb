class AnswersController < ApplicationController
  before_action :set_question, only:[:new, :create]


  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      @notice = "Your answer have been successfully deleted."
      redirect_to @answer.question, notice: @notice
    else
      @notice = "Other user's answer can't be deleted."
      redirect_to @answer.question, notice: @notice
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
