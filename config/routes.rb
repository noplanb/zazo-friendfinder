require 'resque_web'

Rails.application.routes.draw do
  mount ResqueWeb::Engine => '/resque'

  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:create] do
        collection { post :add, :ignore }
      end

      resources :suggestions, only: [:index] do
        collection { post :recommend }
      end

      resources :notifications, only: [] do
        member { post :add, :ignore, :unsubscribe, :subscribe }
      end
    end
  end

  namespace :admin do
    resources :owners, only: [:index, :show] do
      member { post :recalculate, :update_contacts, :fake_notification }
    end

    resources :contacts, only: [:index, :show] do
      member { post :recalculate, :update_info }
    end

    resources :notifications, only: [:index, :show]

    resources :danger_zone, only: [] do
      member { post :drop_contacts, :drop_notifications, :clear_statuses, :mark_as_friend_randomly }
    end

    root to: 'dashboard#index'
  end

  resources :web_client, path: 'w', only: [:show] do
    member do
      get :add, :ignore, :unsubscribe, :subscribe
      post :add_another, :ignore_another
      get :track_email, to: 'web_client/track_emails#index'
    end
  end

  resources :documentation, only: [:show]

  root to: 'documentation#show', id: 'api'

  get 'status', to: Proc.new { [200, {}, ['']] }
end
