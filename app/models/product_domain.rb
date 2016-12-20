class ProductDomain < ApplicationRecord
  belongs_to :domain
  belongs_to :product
end
