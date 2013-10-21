module Subscribem
  class Account < ActiveRecord::Base
    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end
    EXCLUDED_SUBDOMAINS = %w(admin)

    has_many :members, class_name: "Subscribem::Member"
    has_many :users, through: :members

    belongs_to :owner, :class_name => "Subscribem::User"
    accepts_nested_attributes_for :owner

    validates :subdomain, uniqueness: true, presence: true
    validates_exclusion_of :subdomain, in: EXCLUDED_SUBDOMAINS,
                                       message: "is not allowed. Please choose another subdomain."
    validates_format_of :subdomain, with: /\A[\w\-]+\Z/i,
                                    message: "is not allowed. Please choose another subdomain."
  end
end
