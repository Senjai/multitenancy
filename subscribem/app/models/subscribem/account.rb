module Subscribem
  class Account < ActiveRecord::Base
    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end
    EXCLUDED_SUBDOMAINS = %w(admin)

    belongs_to :owner, :class_name => "Subscribem::User"
    accepts_nested_attributes_for :owner

    validates :subdomain, uniqueness: true, presence: true
    validates_exclusion_of :subdomain, in: EXCLUDED_SUBDOMAINS,
                                       message: "is not allowed. Please choose another subdomain."
  end
end
