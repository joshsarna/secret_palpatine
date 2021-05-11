class Api::GamesController < ApplicationController
  def create
    @game = Game.new({
      has_started: false,
      queen_id: nil,
      chancellor_id: nil,
      remaining_republic_policy_count: 6,
      remaining_separatist_policy_count: 11,
      enacted_republic_policy_count: 0,
      enacted_separatist_policy_count: 0,
      appointed_chancellor_id: nil,
      turn_number: 0,
      remaining_policies: ['R', 'R', 'R', 'R', 'R', 'R', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S'].shuffle.join(''),
      failed_election_count: 0,
      current_hand_republic_policy_count: 0,
      current_hand_separatist_policy_count: 0,
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

  def start
    @game = Game.find(params[:id])

    if !@game.has_started
      @game.has_started = true

      players = @game.players
      queen_id = @game.players.find_by({
        turn_number: 0
      })

      if @game.save
        palpatine_count = 1
        if players.length < 7
          separatist_count = 1
          republic_count = players.length - 2
        elsif players.length < 9
          separatist_count = 2
          republic_count = players.length - 3
        else
          separatist_count = 3
          republic_count = players.length - 4
        end
      end

      shuffled_players = players.shuffle
      shuffled_players.each do |player, i|
        if i < palpatine_count
          player.identity = 'palpatine'
        elsif i < palpatine_count + separatist_count
          player.identity = 'separatist'
        else
          player.identity = 'republic'
        end

        player.save
      end
    end

    render 'show.json.jbuilder'
  end

  def show
    @game = Game.find(params[:id])

    render 'show.json.jbuilder'
  end

  def update
    @game = Game.find(params[:id])
    @game.queen_id = params[:queen_id] || @game.queen_id
    @game.chancellor_id = params[:chancellor_id] || @game.chancellor_id
    @game.enacted_republic_policy_count = params[:enacted_republic_policy_count] || @game.enacted_republic_policy_count
    @game.enacted_separatist_policy_count = params[:enacted_separatist_policy_count] || @game.enacted_separatist_policy_count
    @game.appointed_chancellor_id = params[:appointed_chancellor_id] || @game.appointed_chancellor_id
    @game.turn_number = params[:turn_number] || @game.turn_number

    if @game.save
      render 'show.json.jbuilder'
    end
  end
end
