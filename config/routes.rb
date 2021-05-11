Rails.application.routes.draw do
  namespace :api do
    post '/users' => 'users#create'
    post '/sessions' => 'sessions#create'

    post '/games' => 'games#create'
    patch '/games/:id/start' => 'games#start'
    get '/games/:id' => 'games#show'
    patch '/games/:id' => 'games#update'

    post '/players' => 'players#create'
    patch '/players' => 'players#update'

    post '/votes' => 'votes#create'
  end
end
