# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts
  root to: 'home#index'
  get 'home/index'
  get 'home/show'
end
