class Game < ApplicationRecord
  has_many :players
  has_many :votes

  def chancellor
    return players.find(chancellor_id)
  end

  def queen
    return players.find(queen_id)
  end

  def appointed_chancellor
    return players.find(appointed_chancellor_id)
  end

  def can_see_current_hand(current_user)
    player = players.find_by({user_id: current_user.id})
    total_card_count = current_hand_republic_policy_count + current_hand_separatist_policy_count

    if queen_id == player.id && total_card_count == 3
      return true
    elsif chancellor_id == player.id && total_card_count == 2
      return true
    end

    return false
  end

  def can_see_other_identities(current_user)
    player = players.find_by({user_id: current_user.id})
    if player.identity == 'sith'
      return true
    elsif player.identity == 'palpatine'
      return players.length < 7
    end
    return false
  end

  def next_queen
    last_chancellor = chancellor_id
    last_queen = queen_id
    next_turn_number = queen.turn_number
    next_living_queen = nil
    while !next_queen || next_queen.is_dead
      if next_queen
        next_turn_number = next_queen
        next_queen = nil
      else
        next_turn_number += 1
      end
      if next_turn_number === players.length
        next_turn_number = 0
      end

      possible_queen = players.find_by({turn_number: next_turn_number})
      if !possible_queen.is_dead
        next_living_queen = possible_queen
      end
    end
    save()
    return next_living_queen
  end

  def handle_election
    current_votes = votes.where({turn_number: turn_number})
    votes_for = current_votes.where({in_favor: true}).length
    votes_against = current_votes.where({in_favor: false}).length

    if votes_for > votes_against
      # election successful
      failed_election_count = 0
      chancellor_id = appointed_chancellor_id
      appointed_chancellor_id = nil

      chancellor = players.find(chancellor_id)
      if enacted_separatist_policy_count >= 3 && chancellor.identity == 'palpatine'
        end_game('sith', 'Palpatine was elected Supreme Chancellor')
      else
        draw()
      end
      save()
    else
      # election failed
      queen_id = next_queen.id
      chancellor_id = nil
      appointed_chancellor_id = nil

      failed_election_count += 1

      if failed_election_count == 3
        enacted_policy = remaining_policies[-1]
        remaining_policies = remaining_policies[0, remaining_policies.length - 1]
        if enacted_policy == 'S'
          remaining_separatist_policy_count -= 1
          enacted_separatist_policy_count += 1
          en
        elsif enacted_policy == 'R'
          remaining_republic_policy_count -= 1
          enacted_republic_policy_count += 1
        end

        failed_election_count = 0
      end
    end
    turn_number += 1
    save()
  end

  def draw
    hand = remaining_policies[-3, 3].split('')
    remaining_policies = remaining_policies[0, remaining_policies.length - 3]
    current_hand_republic_policy_count = hand.count('R')
    current_hand_separatist_policy_count = hand.count('S')

    remaining_republic_policy_count -= current_hand_republic_policy_count
    remaining_separatist_policy_count -= current_hand_separatist_policy_count

    if remaining_policies.length < 3
      remaining_policies = ['R', 'R', 'R', 'R', 'R', 'R', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S'].shuffle.join('')
      remaining_republic_policy_count = 6
      remaining_separatist_policy_count = 11
    end
  end

  def end_game(game_winner, game_win_reason)
    winner = game_winner
    win_reason = game_win_reason

    players.each do |player|
      user = player.user

      if game_winner == 'sith'
        if player.identity == 'senator'
          user.losses_as_senator += 1
        else
          user['wins_as_' + player.identity] += 1
        end
      else
        if player.identity == 'senator'
          user.wins_as_senator += 1
        else
          user['losses_as_' + player.identity] += 1
        end
      end

      user.save
      save()
    end
  end
end
