Rails.application.routes.draw do
  root 'people#index'

  get 'auth-in-vk', to: 'auth_services#vk'
  resources :people
end
