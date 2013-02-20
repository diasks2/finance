# -*- encoding : utf-8 -*-
Finance::Application.routes.draw do
  root to: 'static_pages#home'
  match '/graph', to: 'static_pages#graph'
  resources :accounts
  resources :transactions
  resources :categories
  resources :groups
end
