class Api::VotesController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.find_by({user_id: current_user.id})

    @vote = Vote.new({
      player_id: player.id,
      game_id: params[:game_id],
      turn_number: game.turn_number,
      in_favor: params[:in_favor]
    })

    if @vote.save
      votes = game.votes.where({turn_number: game.turn_number})
      if votes.length == game.players.length
        game.handle_election
      end

      render 'show.json.jbuilder'
    end
  end
end
