## Page 102

The following code stands as excerpted from the book:

```ruby
module SubdomainHelpers
  def within_account_subdomain
    let(:subdomain_url) { "http://#{account.subdomain}.example.com" }
    before {Capybara.default_host = subdomain_url}
    after {Capybara.default_host = "http://example.com"}
    yield
  end
end
```
The error exists in the after block. The default host actually contains www and sparks an error
on my machine.

I don't think this should be hardcoded. Instead I'd reccommend something along the lines of:

```ruby
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
```

***

## Page 50

First paragraphs text is cut off in the pdf. Also happens in the 5th paragraph on page 49

***