class Domain < ApplicationRecord
  has_many :user_domains
  has_many :shop_domains
  has_many :product_domains
  has_many :users, through: :user_domains
  has_many :products, through: :product_domains
  has_many :shops, through: :shop_domains
end
