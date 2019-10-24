Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :worlds
  get 'worlds/:id/showa', to: 'worlds#showa'
  get 'worlds/:id/showb', to: 'worlds#showb'
  get 'worlds/:id/darkmode', to: 'worlds#darkmode', as: "dark"
  get 'worlds/:id/lightmode', to: 'worlds#lightmode', as: "light"
  get 'worlds/:id/planttint', to: 'worlds#planttint' 
  get 'worlds/index', to: 'worlds#index' 
  get 'worlds/', to: 'worlds#index' 
  get 'worlds/:id', to: 'worlds#show' 
  puts 'worlds/:id/planttint', to: 'worlds#updateplant'
  post 'worlds/:id/planttint', to: 'worlds#edit'

  get '/plants', to: 'plants#index'
  get 'plants/create', to: 'plants#create'
  get 'plants/:id/edit', to: 'plants#edit', as: "plant_edit"
  get 'weathers/:id/edit', to: 'weathers#edit'
  get 'plants/new', to: 'plants#new'

  get 'weathers/createsun', to: "weathers#create"
  get 'weathers/destroysun', to: "weathers#destroy"
  get 'weathers/', to: "weathers#index"
  get 'weathers/index', to: "weathers#index"

  get 'weathers/new', to: "weathers#create"
  get 'weathers/create', to: "weathers#create"
  post 'weathers/createsun', to: "weathers#create"

  post 'plants/create', to: 'plants#create'
  patch 'plants/:id/edit', to: 'plants#update'
  patch 'weathers/:id/edit', to: 'weathers#update'
  post 'plants/new', to: 'plants#new'

  post 'plants/', to: 'plants#index'


  get '/signup', to: "gods#new"
  post '/signup', to: "gods#create"

  get '/login', to: "auth#signin"
  post '/login', to: "auth#verify"


  get '/logout', to: "auth#logout"
root 'worlds#index'

  resources :plants

 # get '/plants/new' => 'plants#new'
#resources :worlds, only: [:showa, :showb]
end
