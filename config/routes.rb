require 'resque_web'

Rails.application.routes.draw do
  mount ResqueWeb::Engine => '/resque'

  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:create] do
        post :add, :ignore, on: :collection
      end
      resources :suggestions, only: [:index] do
        post :recommend, on: :collection
      end
      resources :notifications, only: [] do
        post :add, :ignore, :unsubscribe, :subscribe, on: :member
      end
    end
  end

  namespace :admin do
    resources :owners, only: [:index, :show] do
      post :recalculate, :update_contacts, :fake_notification, on: :member
    end
    resources :contacts, only: [:index, :show] do
      post :recalculate, :update_info, on: :member
    end
    resources :notifications, only: [:index, :show]
    resources :danger_zone, only: [] do
      post :drop_contacts, :drop_notifications, on: :member
    end
    root to: 'dashboard#index'
  end

  resources :web_client, path: 'w', only: [:show] do
    member do
      get :add, :ignore, :unsubscribe, :subscribe
      post :add_another, :ignore_another
    end
  end
  resources :documentation, only: [:show]

  root to: 'documentation#show', id: 'api'

  get 'status', to: Proc.new { [200, {}, ['']] }
end
