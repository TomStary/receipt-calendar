# frozen_string_literal: true

# Routes definitions
Rails.application.routes.draw do
  get 'receipt/calendar'
  get 'receipt/new'
  get 'receipt/list'
  post 'receipt/import'
  get 'receipt/export'

  resources :receipt

  devise_for :users, skip: [:registrations]

  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
