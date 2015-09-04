Rails.application.routes.draw do
  get 'status', to: Proc.new { [200, {}, ['']] }
end
