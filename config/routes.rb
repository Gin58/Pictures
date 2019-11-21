# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/index'
  get 'home/show'
end
