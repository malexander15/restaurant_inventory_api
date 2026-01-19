Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post "login", to: "auth#login"
      post "signup", to: "auth#signup" # optional but recommended
      post "/logout", to: "auth#logout"
      post "/password/forgot", to: "password_resets#create"
      post "/password/reset",  to: "password_resets#update"
      get  "/me",     to: "restaurants#me"
      patch "/me",    to: "restaurants#update"


      resources :products do
        post :replenish, on: :member
        get "by-barcode/:barcode", on: :collection, action: :by_barcode
      end

      resources :recipes do
        post :deplete, on: :member
        resources :recipe_ingredients, only: [:create, :update, :destroy]
      end
    end
  end
end
