Rails.application.routes.draw do
  get 'registrations/create'
  get 'sessions/create'
  devise_for :users
  root 'articles#index'
    resources :articles do
      member do
        post :create_comments
        get  :comments
        post :likes
        delete :unlike
      end
    end
    resources :comments do
      member do
        post :likes 
        delete :unlike
      end
    end
    devise_scope :user do
      post "/sign_in", :to => 'sessions#create'
      post "/sign_up", :to => 'registrations#create'
      put '/change_password', to: 'registrations#change_password'
      get "/profile", :to => 'registrations#profile'
      post "/update_account", :to => 'registrations#update'
    end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
