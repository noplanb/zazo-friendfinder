Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

    end
  end

  get 'status', to: Proc.new { [200, {}, ['']] }
end
