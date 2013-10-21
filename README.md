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

This happens again on page 52 when the error is not as noted. The error is actually an undefined method error for account, because it isn't defined until later on page 52

***

## Private methods in controllers

I'm not sure if I'm entirely correct on this, I remember reading somewhere that controller logic, like the logic in
the application controller should be private as to never be misunderstood as an action. Again, not sure how
accurate that statement is, either way it doesn't seem like they should be part of the public interface.

***

## Page 66

Appendix A as referenced for tips pertinent to installing and using postgres doesn't exist.

***

## Scoping only works in PostgreSQL

If this is the case, it should be added as a dependency in the gemspec instead of a development_dependency as
it should be made clear that the user must use postgres in some fashion

***

## Page 77

The activerecord::statementinvalid error does not occur. This is because after installing psql, we did both
rake db:migrate and RAILS_ENV=test rake db:migrate so these tables do exist in the public schema. This call was made
on page 75

***

## Page 81

The routing error described doesn't occue because previous instruction already included the use_route parameter.
Perhaps this was intended to be removed and added like further instruction suggests after the error is encountered.

***

## Page 82

The first error does not occur and thus the next paragraph describing it doesn't make sense

***