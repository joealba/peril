class ScoresController < ApplicationController
  ###############
  ### Filters ###
  ###############

  before_filter :find_game

  ###############
  ### Actions ###
  ###############

  def create
    @player = @game.players.find_by_id!(params[:player_id])
    if (@answer = @game.last_viewed_answer)
      score = @game.reward_for(@answer).score
      if params[:correct]
        @player.increment(:score, score).save
        return render "answers/confirm"
      else
        @player.decrement(:score, score).save
        return render "answers/show"
      end
    end
    redirect_to(game_path(@game))
  end
end
