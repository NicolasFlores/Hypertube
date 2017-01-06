Rails.application.routes.draw do

  get 'comments/add'

  regex = /[A-Za-z0-9\-\_\+]+/

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session_path
    authenticated  do
        root to: "movies#index"
    end
    unauthenticated do
        root to: "devise/sessions#new"
    end
  end

  devise_for :users, controllers: {
             :sessions => "users/sessions",
             :registrations => "users/registrations",
             :passwords => "users/passwords",
             :confirmations => "users/confirmations",
             :unlocks => "users/unlocks",
             :omniauth_callbacks => "callbacks"
           }

  resources :users

  get 'movies/:id' => 'movies#show'
  post 'movies/download' => 'movies#download'
  get 'movies/stream/:id_movie/:hash' => 'movies#stream'
  get 'movies' => 'movies#index'
  post '/movies/add_movie_collection/:torrent' => 'movies#add_movie_collection' , via: [:post], :as => :add_movie_collection
  post '/comments' => 'comments#add'

end
