Rails.application.routes.draw do
  root to: 'charts#index'
  resources :charts do
    collection do
      get 'px1'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
