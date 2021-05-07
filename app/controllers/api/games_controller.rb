class Api::GamesController < ApplicationController
  def create
    @game = Game.new({
      has_started: false,
      president_id: nil,
      chancellor_id: nil,
      remaining_republic_policy_count: 6,
      remaining_separatist_policy_count: 11,
      enacted_republic_policy_count: 0,
      enacted_separatist_policy_count: 0,
      appointed_chancellor_id: nil,
      turn_number: 0
    })

    if @game.save
      player = Player.create({
        game_id: @game.id,
        user_id: current_user.id,
        turn_number: 0,
        is_dead: false,
        identity: nil
      })

      render 'show.json.jbuilder'
    end
  end
end
