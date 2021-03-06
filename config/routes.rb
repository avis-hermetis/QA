Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      patch :check_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
end
