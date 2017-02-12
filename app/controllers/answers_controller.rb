class AnswersController < ApplicationController
  before_action :set_question, only:[:new, :create]


  def new
    @question = Question.find(params[:question_id])
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
    @answer.destroy
    flash[:notice] = "Your answer have been successfully deleted."
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
