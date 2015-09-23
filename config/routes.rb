require 'resque_web'

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:create]
      resources :suggestions, only: [:index] do
        get :recommend, :reject, on: :collection
      end
    end
  end

  mount ResqueWeb::Engine => '/resque'
  get 'status', to: Proc.new { [200, {}, ['']] }
end
