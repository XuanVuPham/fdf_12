class UserDomain < ApplicationRecord
  belongs_to :user
  belongs_to :domain

  scope :by_domain, -> user, domain do
    where("user_id = ? and domain_id = ?", user, domain)
  end
end
