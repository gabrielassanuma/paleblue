Rails.application.routes.draw do
  get 'tokens/index'
  get 'tokens/new'
  get 'tokens/create'
  get 'tokens/show'
  get 'raffles/new'
  get 'raffles/create'
  get 'raffles/show'
  get 'transactions/new'
  get 'transactions/create'
  get 'transactions/show'
  get 'creators/new'
  get 'creators/create'
  get 'creators/show'
  get 'creators/edit'
  devise_for :creators
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
