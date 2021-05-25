# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.all.each do |user|
  user.total_games_as_sith = user.total_games_as_sith || 0
  user.total_games_as_senator = user.total_games_as_senator || 0
  user.total_games_as_palpatine = user.total_games_as_palpatine || 0
  user.wins_as_sith = user.wins_as_sith || 0
  user.losses_as_sith = user.losses_as_sith || 0
  user.wins_as_senator = user.wins_as_senator || 0
  user.losses_as_senator = user.losses_as_senator || 0
  user.wins_as_palpatine = user.wins_as_palpatine || 0
  user.losses_as_palpatine = user.losses_as_palpatine || 0

  user.save
end