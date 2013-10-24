module Subscribem
  class Account < ActiveRecord::Base
    #Constants

    EXCLUDED_SUBDOMAINS = %w(admin www)

    #Callbacks

    before_validation do
      self.subdomain = subdomain.to_s.downcase
    end

    #Associations

    has_many :members, class_name: "Subscribem::Member"
    has_many :users, through: :members

    belongs_to :owner, :class_name => "Subscribem::User"
    accepts_nested_attributes_for :owner

    #Validations

    validates :subdomain, uniqueness: true, presence: true
    validates_exclusion_of :subdomain, in: EXCLUDED_SUBDOMAINS,
                                       message: "is not allowed. Please choose another subdomain."
    validates_format_of :subdomain, with: /\A[\w\-]+\Z/i,
                                    message: "is not allowed. Please choose another subdomain."

    #Class Methods

    def self.create_with_owner(params = {})
      account = new(params)
      if account.save
        account.users << account.owner
      end
      account
    end

    #Instance Methods

    def create_schema
      Apartment::Database.create(subdomain)
    end

    def owner?(user)
      owner == user
    end
  end
end
