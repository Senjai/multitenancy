Apartment.excluded_models = %w{Subscribem::Account Subscribem::Member Subscribem::User Subscribem::Plan}
Apartment.database_names = lambda {Subscribem::Account.pluck(:subdomain)}