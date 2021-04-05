Rails.application.routes.draw do
  apipie

  defaults format: :json do
    resources :tasks
    resources :users

    namespace 'me' do
      resources :tasks
    end

    scope '/auth' do
      get '/me', to: 'authentication#me'
      post '/register', to: 'authentication#register'
      post '/login', to: 'authentication#login'
      # post '/password-forgot', to: 'authentication#password_forgot'
      # post '/password-reset', to: 'authentication#password_reset'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
