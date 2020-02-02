# frozen_string_literal: true

Rails.application.routes.draw do
  root 'budgets#index'

  devise_for :users
  resources :users, only: %i[show edit update]

  resources :budgets, only: %i[index] do
    resources :operations, only: %i[index create destroy]
  end
end
