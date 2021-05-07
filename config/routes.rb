RedBook::red_book
Rails.application.routes.draw do
  post '/users' => 'users#create'
  post '/sessions' => 'sessions#create'

  post '/games' => 'games#create'
  patch '/games/:id/start' => 'games#start'

  post '/players' => 'players#create'
end
