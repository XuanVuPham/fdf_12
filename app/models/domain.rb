class Domain < ApplicationRecord
  has_many :user_domains
  has_many :users, through: :user_domains
end
