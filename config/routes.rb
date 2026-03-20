Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  post "sign_up", to: "registrations#create"

  post   "sign_in",  to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"

  namespace :books do
    resource :total,     only: :show
    resource :due_today, only: :show
  end

  resources :books do
    resources :borrowings
  end

  namespace :members do
    resource :with_overdue_books, only: :show
  end

  namespace :my do
    resource :borrowed_books
  end
end
