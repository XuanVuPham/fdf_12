class DomainsController < ApplicationController
  def index
    @shops = []
    @products = []
    if user_signed_in?
      @domains = current_user.domains
      @users = []
      @domains.each do |domain|
        @users += domain.users
        @users.each do |user|
          @shops += user.shops
        end
      end
      @shops = @shops[0..5]
      @shops.each do |shop|
        @products += shop.products
      end
      @products = @products[0..7]
    else
      @shops = Shop.top_shops.decorate
      @products = Product.top_products
    end
    @catogories = Category.all
    @tags = ActsAsTaggableOn::Tag.all
  end
end
