class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :question_load, only: [:show, :destroy, :update, :vote]

  respond_to :json, only: :vote

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
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
    if current_user&.author_of?(@question)
      @question.destroy
      flash[:notice] = "Your question have been successfully deleted."
    else
      flash[:notice] = "You can't delete other user's question."
    end
    redirect_to questions_path
  end

  def vote
    @question.vote(params[:vote], current_user)

  end

  private

  def check_vote
    if params[:vote].blank? || !%w(up down).includes?(params[:vote])
      render json: {errors: ["invalid vote for answer #{@question.id}"]}, status: 422
    end
  end

  def question_load
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
