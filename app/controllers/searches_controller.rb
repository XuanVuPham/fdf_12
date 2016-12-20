class SearchesController < ApplicationController
  def index
    q = params[:search]
    if user_signed_in? && params[:domain_id].present?
      domain = Domain.find_by id: params[:domain_id]
      products = domain.products.active.search(name_or_description_cont: q).result
        .includes :shop
      shops = domain.shops.search(name_or_description_or_owner_name_cont: q).result
        .includes(:owner).decorate
    else
      products = Product.active.search(name_or_description_cont: q).result
        .includes :shop
      shops = Shop.search(name_or_description_or_owner_name_cont: q).result
        .includes(:owner).decorate
    end
    @items = products + shops
    respond_to do |format|
      format.js
      format.html
    end
  end
end
