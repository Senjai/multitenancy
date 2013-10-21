HostedForums::Application.routes.draw do
  mount Subscribem::Engine, at: "/"
end
