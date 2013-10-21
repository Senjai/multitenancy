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

## Page 51

In the code:

```ruby
<h2>Sign Up</h2>
<%= form_for(@user, url: do_user_sign_up_url) do |user| %>
  <%= render 'subscribem/account/users/form', user: user %>
  <%= user.submit "Sign up" %>
<% end %>
```

it isn't obvious what do_user_sign_up_url does. At this point it is undefined and gives the reader pause.
After running the test, it doesn't come up with a routing error as dictated, instead it comes up with
a method not defined. I would suggest restating the error is a result of both not having the route defined
nor having the alias for the route defined to get rid of the no method defined error.

***