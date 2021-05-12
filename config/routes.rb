Rails.application.routes.draw do
  namespace :api do
    post '/users' => 'users#create'
    post '/sessions' => 'sessions#create'

    get '/games/:id/peak' => 'games#peak'
    post '/games' => 'games#create'
    patch '/games/:id/start' => 'games#start'
    get '/games/:id' => 'games#show'
    patch '/games/:id' => 'games#update'

    post '/players' => 'players#create'
    get '/players/:id' => 'players#show'
    patch '/players/:id' => 'players#update'

    post '/votes' => 'votes#create'
  end
end
