module Subscribem
  module TestingSupport
    module SubdomainHelpers
      def within_account_subdomain
        let(:subdomain_url) { "http://#{account.subdomain}.example.com" }
        before {
          @current_host = Capybara.default_host
          Capybara.default_host = subdomain_url
        }
        after {Capybara.default_host = @current_host}
        yield
      end
    end
  end
end