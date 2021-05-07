RedBook::red_book
Rails.application.routes.draw do
  post '/users' => 'users#create'
  post '/sessions' => 'sessions#create'

  post '/games' => 'games#create'

  post '/players' => 'players#create'
end
