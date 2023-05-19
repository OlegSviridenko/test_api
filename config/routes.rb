Rails.application.routes.draw do
  resources :glossaries, only: %i[index show create] do
    member do
      post 'term' => 'glossaries#create_term'
    end
  end

  resources :translations, only: %i[create show]
end
