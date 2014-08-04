Tincanz::Engine.routes.draw do

  

  resources :conversations, only: [:index, :show, :new, :create] do
    resources :messages, only: [:new, :create]
  end

  namespace :admin do
    resources :users, only: [:index, :show]
    resources  :conversations, only: [:index, :show, :new, :create] do
      resource   :assignee, only: :update, controller: 'assignees'
      resources  :messages, only: [:new, :create]
    end
  end

end
