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
require 'subscribem/testing_support/factories/account_factory'
3 require 'forem/testing_support/factories/categories'
4 require 'forem/testing_support/factories/forums'
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

Interlude,

A couple of other things i've noticed.. While using the subdomain as a way to scope schemas, a problem arises still when www is used before the domain name. It is considered/thought to be a subdomain and Apartment looks for it as a schema.

***

## Page 132

Oddly, the error I get with this exact code is:
```
Failures:

  1) BraintreePlanFetcher checks and updates plans
     Failure/Error: BraintreePlanFetcher.store_locally
       (<Subscribem::Plan(id: integer, name: string, price: float, braintree_id: string, created_at: datetime, updated_at: datetime) (class)>).create({:name=>"starter", :price=>"9.95", :braintree_id=>"faux1"})
           expected: 0 times with any arguments
           received: 1 time with arguments: ({:name=>"starter", :price=>"9.95", :braintree_id=>"faux1"})
     # ./lib/subscribem/braintree_plan_fetcher.rb:4:in `block in store_locally'
     # ./lib/subscribem/braintree_plan_fetcher.rb:3:in `each'
     # ./lib/subscribem/braintree_plan_fetcher.rb:3:in `store_locally'
     # ./spec/integration/braintree_plan_fetchet_spec.rb:32:in `block (2 levels) in <top (required)>'
```
Commenting out the call to create will generate the proper error while making the previous test fail.

This is the first thing to pop up when its in the test, though once the implimentation is complete as it stands on 133 both tests still pass.

***

## Page 134

Still plan select screen todo. Is this something you intend to impliment or is an exercise left for the reader?

***

## Page 136

account_path should be edit_account_path as that is the route that you define in config/routes.rb

on page 138, account_path also needs to be defined. So the route that you make subsequently needs to be aliased.

Note that because edit_account_path is used in the _login partial thats shared with the application it should be in fact called as subscribem.edit_account_path

***

## Page 139

Test fails.

Issue with warden test helpers seemingly only keeping a user logged in for a single request, as you requested this is your suggested change to the test.
```ruby
  context "as the account owner" do
    scenario "Updating an account" do
      visit root_url
      fill_in "Email", :with => account.owner.email
      fill_in "Password", :with => "password"
      click_button "Sign In"
      click_link "Edit Account"
      fill_in "Name", with: "A new name"
      click_button "Update Account"
      page.should have_content("Account updated successfully.")
      account.reload.name.should == "A new name"
    end
  end
```
As it seems to work fine with a regular sign in.

Also, this controller should probably make use of the authenticate_user! before_filter and perhaps even another one to make sure that the user accessing the controller is in fact the owner. per sevenseacat

EDIT**

later because we use another scenario in this test, I moved the authentication into a before block like the original helper was in.

```ruby
context "as the account owner" do
    before do
      visit root_url
      fill_in "Email", :with => account.owner.email
      fill_in "Password", :with => "password"
      click_button "Sign In"
    end

    scenario "Updating an account" do
      click_link "Edit Account"
      fill_in "Name", with: "A new name"
      sign_in_as(user:account.owner, account: account)
      click_button "Update Account"
      page.should have_content("Account updated successfully.")
      account.reload.name.should == "A new name"
    end
  end
```

***

## sign_in_as

I believe that signing in with the account scope is no longer needed.

This is because current_account which is used in almost every scenario determins the current account based on request.subdomain

This may change later in the book though, so I'm not sure.

***

## Binstubs

I don't use them, but I just noticed that at some point in the book you started using them, but haven't instructed the user that you would be, or how to generate them with bundler if they want to do the same.

***

## Page 150

This example of using only to scope the owner before_filter, and the previous one where it was originally implimented is redundant because all actions currently require only status. Additionally, it may be subjective but I read somewhere whitelisting is better than blacklisting. E.g. the safe rather than sorry route. In that case I would use except instead of only.

***

## Page 152

Text on the link is also cut off on the pdf.

I dont ever remember putting the initializer in hosted_forums. Instead I stupidly out it in the engines initializer... I must've been tired. On page 130 however, you didn't specify exactly where to put the initializer. It can kind of be confusing at times when you're dealing with three config/initializer directories in the book, one for the engine, the hosted_forum, and the dummy application. Expanding these paths might reduce pause and make things more clear. And prevent dummies like me from making hugely obvious nono's.

***

## Page 154

I would really like to develop the fake_braintree_redirect instead of just including it. You could mix it into your book if you dont do anything else with Rack::Middleware, if you do I havent gotten there yet ;)

***

## Page 156

`#{plan.name} should be #{@plan.name}` inside the flash message

***

## Page 157

This test does not pass for me as is. I get the error below:

```
1) Accounts as the account owner with plans updating an accounts plan
     Failure/Error: click_button "Change plan"
       Braintree::TransparentRedirect received :confirm with unexpected arguments
         expected: ("plan_id=2&http_status=200&id=a+fake+id&kind=create_customer&hash=%3Chash%3E")
              got: ("plan_id=2&http_status=200&id=a_fake_id&kind=create_customer&hash=8bb5b10a27f828afef46d033cb4ac900bc3653fd")
     # ./app/controllers/subscribem/account/accounts_controller.rb:31:in `subscribe'
     # ./spec/feature/accounts/updating_spec.rb:88:in `block (4 levels) in <top (required)>'
```

Since the hash is generated from the data (I think) and the data doesnt change, I just copied the generated hash and it passes. Not sure if this is the best way to go about it.

Additionally, I had to replace the spaces in the id field for Rack::Utils with underscores, as it seems to convert them to +'s

and I had to add a '/' to the end of root_url because page.current_url had a trailing forward slash.

`page.current_url.should == root_url + "/"`

***

## Page 158

It feels like this should have a new subheading, or something to sepearte the sections from changing payment plans to setting up subscriptions.

At the bottom, the reference to the test is sorta ambigious thogh it can be inferred.

***

## Page 160

Booo, just got to http://lvh.me:3000 and the rest is history. I can understand not wanting to link to an external entity in a book, but just a suggestion, it's a way to accomplish the same thing without having to change your hosts file.

More importantly, worth mentioning a `rake railties:install:migrations` is required to bring the plan_id migration over from the engine.

Also, to migrate the applications test database, you need the fake_braintree_redirect gem which isn't resolved as a dependency because it isn't in the gemspec. You have to add this manually in your applications gemfile under the test environment

***

## Page 161

The credit card number you say to use is actually invalid, you need one more 1 :P

***

## Page 164

I just noticed that your code here differs from code in previously. Some code is formatted with line numbers, some code like this is not. I personally prefer without line numbers, but just something I've noticed.

***

## Page 166

Originally @result wasn't an instance variable. I missed this when the test passed :P Worth noting the change?

***

## Page 169

If you follow my reccomendation to move the sign in process into the before block for this context you should remove the `visit root_url` from this test.

***

## Page 174

Aha! you return to line numbers :P

```ruby
let(:account) do
8 account = FactoryGirl.create(:account_with_schema).tap(&:save)
9 end
```
`account =` and the tap statement are redundant. You don't need to save when you're using create.

***

## Page 177

Fini!

One last check should be done to determine the limit for users without a plan aka on the free plan.

***

## Feedback

I really liked this book! And I really want to generate more feedback but I'll do it tomorrow! Because I'm so god damn tired, its 4:30 am here.

Until tomorrow then, 4.5/5 for the book, I'll go into detail later :P

***