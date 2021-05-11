json.id @game.id
json.has_started @game.has_started
json.queen_id @game.queen_id
json.chancellor_id @game.chancellor_id
json.enacted_republic_policy_count @game.enacted_republic_policy_count
json.enacted_separatist_policy_count @game.enacted_separatist_policy_count
json.appointed_chancellor_id @game.appointed_chancellor_id
json.turn_number @game.turn_number

json.current_hand_republic_policy_count @game.can_see_current_hand(current_user) ? @game.current_hand_republic_policy_count : nil
json.current_hand_separatist_policy_count @game.can_see_current_hand(current_user) ? @game.current_hand_separatist_policy_count : nil

json.players @game.players do |player|
  json.id player.id
  json.turn_number player.turn_number
  json.is_dead player.is_dead
  json.name player.user.name
end

json.i_am_queen @game.queen_id === current_user.id
json.i_am_chancellor @game.chancellor_id === current_user.id
json.i_am_appointed_chancellor @game.appointed_chancellor_id === current_user.id