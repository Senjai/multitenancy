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

## Page 75

The version of apartment used as the dependency must be set to 0.22.1 not 0.22.0. This ensures proper reporting of error messages when you get to Page 89 when you attempt to fix the tests that are broken.

The error messages on 0.22.0 are weird and are arguement error messages instead of schema not available.

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

## Schema Logic Suggestion

Currently, (so far) the logic for creating a schema is in the controller. I agreed with create_with_user as there are situations in whcih you would want to create and account without a user and it shouldn't be placed in a callback. That said, is there ever a time you'd create an account without an associated schema?

Would it be best to put that in an after_create callback on the model, or even better in a ActiveRecord::Concern?

***

## Page 86

First paragraphs text is cut off.

let!(:account_a) { FactoryGirl.create(:account_with_schema) }
ActiveRecord::StatementInvalid:
PG::Error: ERROR: current transaction is aborted,
commands ignored until end of transaction block
: SET search_path TO public

This error doesn't occur for me.

***

## Page 91

Note that after refactoring current_account, calling it when the subomdain is nonexistant or www will raise an exception. I think.. Maybe not because it doesnt have a bang at the end of it. Either way it's the first thing that comes to mind

***

## Subdomains

For those that might test the app in development, a quick mention to http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme may be relevant. Either in a footnote or the like. Simply going to lvh.me:port will redirect you to localhost, but you wont have to modify your /etc/hosts file everytime you add a new subdomain because DNS allows wildcards, host files do not.

***

## Page 99

Do you have to include require capybara/rspec in test helper to make capybara work? What about adding rspec to the generators?

Also when you're talking about where to put the partial code, or where to place it is initally ambigious whether you're talking about the engine or the application.

***

## Page 101

It is not immediately obvious that you intend this feature to be in a SEPERATE file than the one above. Sign up and sign in are very similar, might be best to state that this is a new file?

***

## Factory sharing, page 104

Wouldn't this be easier to have spec_helper.rb autoload all factories from testing_support/factories/**/*.rb? Considering that factory usage is pretty widespread? Or is this violating some sort of design rule?

This could also be done in the applications spec_helper. Not an error per say, I'm just curious on your thoughts.

***

## Forem Monkey Patch, page 105

On page 105, the monkey patch doesn't make it obvious that Forem::ApplicationController also inherits from ::ApplicationController and thus will have the authenticate_user! method as subscribem patched it into the applications controller and therefore forems controller. Worth a mention.

***

## Page 111

Using database cleaner with before(:suite) works fine for the application, but tests in the engine were no longer passing. before(:all) worked for both the application and the engine. This gave me a bit of grief and I'm still not exactly sure what was happening. Should be able to provide more info if this works fine for you.

***

## Page 113 Proving a Fault

So I noticed something pretty large here, the test in the book passes. This is because while we set the session_store initializer in the dummy app in subscribem, we did not do so in this application. There are two options, allow the session to transverse over the domain, or re-sign in. I prefer the latter, but this might need to be addressed from your standpoint.

If you do not choose to change session_store.rb from the default, the proper test code would look like this:

```ruby
scenario "is only the forum admin for one account" do
  visit "http://#{account_a.subdomain}.example.com"
  fill_in "Email", with: account_a.owner.email
  fill_in "Password", with: "password"
  click_button "Sign In"

  page.should have_content("Admin Area")

  visit "http://#{account_b.subdomain}.example.com"
  fill_in "Email", with: account_a.owner.email
  fill_in "Password", with: "password"
  click_button "Sign In"
  page.should_not have_content("Admin Area")
end
```

***

## Page 117

Worth mentioning that after these overrides are complete, a migration could be created to drop these columns that have been added by forem.

***