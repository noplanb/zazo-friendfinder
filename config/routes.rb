require 'resque_web'

Rails.application.routes.draw do
  mount ResqueWeb::Engine => '/resque'

  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:create]
      resources :suggestions, only: [:index] do
        get :recommend, :reject, on: :collection
      end
    end
  end

  resources :templates, except: [:show]
  resources :web_client, path: 'w', only: [:show] do
    get :add, :ignore, :unsubscribe, on: :member
    post :add_another, on: :member
  end
  resources :documentation, only: [:show]

  get 'status', to: Proc.new { [200, {}, ['']] }
end
