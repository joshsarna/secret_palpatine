class Api::PlayersController < ApplicationController
  def create
    game = Game.find(params[:game_id])

    @player = game.players.find_by({user_id: current_user.id})

    if !@player
      @player = Player.new({
        game_id: game.id,
        user_id: current_user.id,
        turn_number: game.players.length,
        is_dead: false,
        identity: nil
      })

      if @player.save
        render 'show.json.jbuilder'
      end
    else
      render 'show.json.jbuilder'
    end
  end
end
