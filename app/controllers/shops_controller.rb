class ShopsController < ApplicationController
  before_action :load_shop, only: [:show, :update]
  before_action :load_domain, only: [:index, :show]

  def index
    @shops = if @domain.present?
      @domain.shops.active.page(params[:page])
        .per(Settings.common.per_page).decorate
    else
      Shop.active.page(params[:page])
        .per(Settings.common.per_page).decorate
    end
  end

  def show
    @products = @shop.products.active.page(params[:page])
      .per Settings.common.products_per_page
    @shop = @shop.decorate
  end

  def update
    user = User.find_by email: params[:email]
    if user
      @shop.update_attributes owner_id: user.id
      flash[:success] = t "change_shop"
      redirect_to root_path
    else
      flash[:danger] = t "cant_not_find_shop"
      redirect_to :back
    end
  end

  private
  def load_shop
    if Shop.exists? params[:id]
      @shop = Shop.find params[:id]
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to root_path
    end
  end
end
