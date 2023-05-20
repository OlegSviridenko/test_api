Rails.application.routes.draw do
  resources :glossaries, only: %i[index show create] do
    post 'terms' => 'glossaries#create_term'
  end

  resources :translations, only: %i[create show]
end
