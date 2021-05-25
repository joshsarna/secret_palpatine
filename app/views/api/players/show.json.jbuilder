json.id @player.id
json.name @player.user.name
json.turn_number @player.turn_number
json.is_dead @player.is_dead
json.identity @player.user_id == current_user.id ? @player.identity : (@player.identity == 'palpatine' ? 'sith' : @player.identity)