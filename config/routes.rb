# frozen_string_literal: true

Rails.application.routes.draw do
  root 'budgets#index'

  devise_for :users
  resources :users, only: %i[show edit update]
  resources :categories, except: %i[show]

  resources :budgets, except: %i[edit update] do
    resources :operations, only: %i[index new create destroy]
  end
end
