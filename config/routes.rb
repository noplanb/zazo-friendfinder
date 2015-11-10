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

  resources :templates
  resources :documentation, only: [:show]

  get 'status', to: Proc.new { [200, {}, ['']] }
end
