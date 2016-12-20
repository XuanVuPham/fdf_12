class Admin::UserDomainsController < ApplicationController
  before_action :load_params
  def new
    @shops.each do |shop|
      ShopDomain.new(shop_id: shop.id, domain_id: @domain.id).save
    end
    @products.each do  |product|
      ProductDomain.new(product_id: product.id, domain_id: @domain.id).save
    end
    unless @user.domains.include? @domain
      user_domain = UserDomain.new user_id: params[:user_id],
        domain_id: params[:domain_id]
      if user_domain.save
        flash[:success] = t "add_domain"
      else
        flash[:danger] = t "not_add_domain"
      end
    end
    redirect_to :back
  end

  def destroy
    @shops.each do |shop|
      ShopDomain.find_by(shop_id: shop.id, domain_id: params[:domain_id]).destroy
    end
    @products.each do  |product|
      ProductDomain.find_by(product_id: product.id, domain_id: params[:domain_id]).destroy
    end
    @user_domain = UserDomain.find_by id: params[:id]
    if @user_domain.destroy
      flash[:success] = t "delete_domain"
    end
    redirect_to :back
  end

  private
  def load_params
    @user = User.find_by id: params[:user_id]
    @domain = Domain.find_by id: params[:domain_id]
    @user_domain = UserDomain.find_by id: params[:id]
    @shops = @user.shops
    @products = @user.products
  end
end
