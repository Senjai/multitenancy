require 'subscribem/constraints/subdomain_required'

HostedForums::Application.routes.draw do

  constraints(Subscribem::Constraints::SubdomainRequired) do
    mount Forem::Engine, at: "/"
  end

  mount Subscribem::Engine, at: "/"
end
