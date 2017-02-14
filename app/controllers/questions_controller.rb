class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :question_load, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
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
      flash[:notice] = "Fail to save the question."
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = "Your question have been successfully deleted."
    else
      flash[:notice] = "You can't delete other user's question."
    end
    redirect_to questions_path
  end

  private

  def question_load
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
