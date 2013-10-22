require 'subscribem/constraints/subdomain_required'

HostedForums::Application.routes.draw do

  constraints(Subscribem::Constraints::Subdomain) do
    mount Forem::Engine, at: "/"
  end

  mount Subscribem::Engine, at: "/"
end
