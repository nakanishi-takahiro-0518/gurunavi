Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'restaurants#search'
  get 'restaurant' => 'restaurants#index', as: 'rests'
  get 'restaurant/:id' => 'restaurants#show', as: 'rest'
end
