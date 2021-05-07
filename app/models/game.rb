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

  def can_see_current_hand
    player = players.find_by({user_id: current_user.id})
    total_card_count = current_hand_republic_policy_count + current_hand_separatist_policy_count
    
    if queen_id == player.id && total_card_count == 3
      return true
    elsif chancellor_id == player.id && total_card_count == 2
      return true
    end

    return false
  end
end
