class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :question_load, only: [:show]

  def index
    @questions = Question.all
  end

  def show

  end

  def new
    @question = Question.new
  end


  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:notice] = "Your question have been successfully created."
      redirect_to @question
    else
      render :new
    end
  end

  private

  def question_load
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
