# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts, controllers: {
    registrations: 'accounts/registrations',
    sessions: 'accounts/sessions'
  }

  devise_scope :account do
    get 'sign_in', to: 'accounts/sessions#new'
    get 'sign_out', to: 'accounts/sessions#destroy'
  end

  root to: 'home#index'
  get 'home/index'
  get 'home/show'
end
