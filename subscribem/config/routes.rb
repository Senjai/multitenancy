require 'subscribem/constraints/subdomain_required'

Subscribem::Engine.routes.draw do
  constraints(Subscribem::Constraints::SubdomainRequired) do
    scope :module => "account" do
      get '/sign_in', :to => "sessions#new"
      post '/sign_in', :to => "sessions#create", :as => :sessions
      get '/sign_up', :to => "users#new", :as => :user_sign_up
      post '/sign_up', :to => "users#create", :as => :do_user_sign_up
      get '/account', to: "accounts#edit", as: :edit_account
      patch '/account', to: "accounts#update", as: :account
      get '/account/plan/:plan_id', to: "accounts#plan", as: :plan_account
      get '/account/subscribe', to: "accounts#subscribe", as: :subscribe_account
      post '/account/confirm_plan', to: "accounts#confirm_plan", as: :confirm_plan_account

      root to: "dashboard#index", as: :account_root
    end
  end

  get '/sign_up', :to => "accounts#new", :as => :sign_up
  post '/accounts', :to => "accounts#create", :as => :accounts

  root to: "dashboard#index"
end
