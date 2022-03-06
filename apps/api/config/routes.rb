# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  apipie

  defaults format: :json do
    resources :links
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
    resources :users do
      collection do
        get :random, to: 'users#random'
        post :verify_email, to: 'users#verify_email'
        post :verify_username, to: 'users#verify_username'
      end
    end

    get '/users/:id/tasks', to: 'user_tasks#index'
    get '/users/:id/task_groups', to: 'user_task_groups#index'
    get '/users/:user_id/tasks/:id', to: 'user_tasks#show'

    get '/projects/:id/task_groups', to: 'project_task_groups#index'

    namespace 'me' do
      resources :tasks
      resources :webhooks
      resources :projects do
        resources :project_screenshots, path: 'screenshots'
        resources :project_webhooks, path: 'webhooks'

        member do
          get :github, to: 'projects#github'
        end
      end

      get '/email_notifications', to: 'email_notifications#index'
      put '/email_notifications', to: 'email_notifications#update'
      put '/profile', to: 'profile#update'
    end

    scope '/auth' do
      get '/me', to: 'authentication#me'
      post '/register', to: 'authentication#register'
      post '/email_validation', to: 'authentication#email_validation'
      post '/login', to: 'authentication#login'
      post '/forgot-password', to: 'authentication#forgot_password'
      post '/reset-password', to: 'authentication#reset_password'
    end

    namespace 'webhooks' do
      resources :projects do
        member do
          post :github, to: 'projects#github'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
# rubocop:enable Metrics/BlockLength

Rails.application.routes.default_url_options[:host] = ENV.fetch('ASSET_HOST', 'https://api.checkmark.dev')
