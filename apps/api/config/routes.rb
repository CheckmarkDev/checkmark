# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  apipie

  defaults format: :json do
    resources :projects
    resources :task_groups
    resources :tasks do
      member do
        post :like
        delete :like, to: 'tasks#dislike'
      end

      resources :task_comments, path: 'comments'
      resources :task_likes, path: 'likes'
    end
    resources :users

    get '/users/:id/tasks', to: 'user_tasks#index'
    get '/users/:id/task_groups', to: 'user_task_groups#index'
    get '/users/:user_id/tasks/:id', to: 'user_tasks#show'

    get '/projects/:id/task_groups', to: 'project_task_groups#index'

    namespace 'me' do
      resources :tasks
      resources :projects do
        resources :project_screenshots, path: 'screenshots'
      end

      get '/email_notifications', to: 'email_notifications#index'
      put '/email_notifications', to: 'email_notifications#update'
      put '/profile', to: 'profile#update'
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
# rubocop:enable Metrics/BlockLength

Rails.application.routes.default_url_options[:host] = ENV.fetch('ASSET_HOST', 'https://api.checkmark.dev')
