RedBook::red_book
Rails.application.routes.draw do
  post '/users' => 'users#create'
  post '/sessions' => 'sessions#create'

  post '/games' => 'games#create'
  patch '/games/:id/start' => 'games#start'
  get '/games/:id' => 'games#show'
  patch '/games/:id' => 'games#update'

  post '/players' => 'players#create'
end
