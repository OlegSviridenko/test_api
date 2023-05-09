Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :glossaries do
    member do
      post 'term' => 'glossaries#create_term'
    end
  end
end
