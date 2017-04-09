class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :question_load, only: [:show, :destroy, :update, :vote]
  before_action :check_vote, only: [:vote]

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
    if rating = @question.vote(params[:vote].to_sym, current_user)
      render json: @question, status: 200
    else
      render json: { errors: ["you have already voted"]}, status: 403
    end
  end

  private

  def check_vote
    if params[:vote].blank? || !%w(up down).include?(params[:vote])
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
