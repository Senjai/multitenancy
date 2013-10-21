Rails.application.routes.draw do

  get "/things", to: "things#index", as: :things
  mount Subscribem::Engine => "/"
end
