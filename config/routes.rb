Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :products
      resources :recipes do
        post :deplete, on: :member
        resources :recipe_ingredients, only: [:create, :update, :destroy]
      end
    end
  end
end
