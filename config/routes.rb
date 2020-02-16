# frozen_string_literal: true

Rails.application.routes.draw do
  root 'budgets#index'

  devise_for :users
  resources :users, only: %i[show edit update]
  resources :categories, except: %i[show]
  resources :payment_methods, except: %i[show]
  resources :stats, only: %i[index show]

  resources :budgets, except: %i[edit update] do
    resources :operations, except: %i[show index]
  end
end
