require 'warden'
require "dynamic_form"
require "apartment"
require "braintree"

module Subscribem
  class Engine < ::Rails::Engine
    isolate_namespace Subscribem

    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end

    initializer "subscribem.middleware.warden" do
      Rails.application.config.middleware.use Warden::Manager do |manager|
        manager.default_strategies :password
      end
    end

    initializer "subscribem.middleware.apartment" do
      Rails.application.config.middleware.use Apartment::Elevators::Subdomain
    end

    initializer "subscribem.middleware.fake_braintree_redirect" do
      if Rails.env.test?
        require 'fake_braintree_redirect'
        Rails.application.config.middleware.insert_before \
          Apartment::Elevators::Subdomain, FakeBraintreeRedirect
      end
    end

    config.to_prepare do
      root = Subscribem::Engine.root
      extenders_path = root + "app/extenders/**/*.rb"
      Dir.glob(extenders_path) do |file|
        Rails.configuration.cache_classes ? require(file) : load(file)
      end
    end
  end
end
