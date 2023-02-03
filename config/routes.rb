Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get "user/:id", :to => "users/registrations#detail"
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root to: 'home#index'
  get 'users/profile', to: 'users#profile'
  post 'users/profile', to: 'users#update'
end
