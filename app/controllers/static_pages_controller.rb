class StaticPagesController < ApplicationController

  def home
    @catogories = Category.all
    @tags = ActsAsTaggableOn::Tag.all
    if request.subdomains(0).first and user_signed_in?
      @domain = Domain.find_by subdomain: request.subdomains(0).first
      if !@domain.present? or !current_user.domains.include? @domain
        flash[:danger] = t "can_not_find_link"
        @products = Product.top_products
        @shops = Shop.top_shops.decorate
      else
        @shops = @domain.shops.top_shops.decorate
        @products = @domain.products.top_products
      end
    else
      @products = Product.top_products
      @shops = Shop.top_shops.decorate
      flash[:danger] = t "have_to_sign_in"
    end
  end
end
