class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :votes
end
