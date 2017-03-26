class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_votable, only: :create



  def create
    if params[:rating] = 'increase'
      @vote = @votable.votes.build(vote: 1)
    else
      @vote = @votable.votes.build(vote: -1)
    end
    respond_to do |format|
      if @vote.save
        format.json {render json: @vote.votable}
      else
        format.json {render json: @vote.errors.full_messages, status: unprocessable_entity}
      end
    end
  end

  def destroy
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.rating_update
        format.json {render json: @vote.votable}
      else
        format.json {render json: @vote.errors.full_messages, status: unprocessable_entity}
      end
    end
  end
  private

  def set_votable
    votable_id = params.keys.detect{ |k| k.to_s =~ /.*_id/ }
    model_klass = votable_id.chomp('_id').classify.constantize
    @votable = model_klass.find(params[votable_id])
  end
end
