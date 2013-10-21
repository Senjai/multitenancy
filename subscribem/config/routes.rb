require 'subscribem/constraints/subdomain_required'

Subscribem::Engine.routes.draw do
  constraints(Subscribem::Constraints::SubdomainRequired) do
    scope :module => "account" do
      get '/sign_in', :to => "sessions#new"
      post '/sign_in', :to => "sessions#create", :as => :sessions
      get '/sign_up', :to => "users#new", :as => :user_sign_up
      post '/sign_up', :to => "users#create", :as => :do_user_sign_up
      root to: "dashboard#index", as: :account_root
    end
  end

  get '/sign_up', :to => "accounts#new", :as => :sign_up
  post '/accounts', :to => "accounts#create", :as => :accounts

  root to: "dashboard#index"
end
