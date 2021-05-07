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
end
