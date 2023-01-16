Rails.application.routes.draw do
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
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
end
