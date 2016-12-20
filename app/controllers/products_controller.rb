class ProductsController < ApplicationController
  before_action :load_domain
  def index
    if @domain.present?
      @products = @domain.products.active.page(params[:page])
        .per Settings.common.products_per_page
    else
      @products = Product.active.page(params[:page])
        .per Settings.common.products_per_page
    end
  end

  def new
    @product = Product.new
  end

  def show
    if Product.exists? params[:id]
      @product = Product.find params[:id]
      @comment = @product.comments.build
      @comments = @product.comments.newest.includes :user
    else
      flash[:danger] = t "product.not_product"
      redirect_to products_path
    end
  end
end
