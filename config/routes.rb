Rails.application.routes.draw do
  resources :books do
    member do
      put :update_status
    end
  end
end
