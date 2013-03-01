# -*- encoding : utf-8 -*-
Finance::Application.routes.draw do
  root to: 'static_pages#home'
  match '/graph1', to: 'static_pages#graph1'
  match '/graph2', to: 'static_pages#graph2'
  match '/networth', to: 'static_pages#networth'
  match '/income', to: 'static_pages#income'
  match '/balance', to: 'static_pages#balance'
  resources :accounts
  resources :transactions
  resources :categories
  resources :groups
  resources :rates
end
