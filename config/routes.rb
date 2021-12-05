# frozen_string_literal: true

# Routes definitions
Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
