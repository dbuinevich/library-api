Rails.application.routes.draw do
  resources :books, except: [:edit, :update] do
    member do
      patch :update_status
    end
  end
end
