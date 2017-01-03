class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :create_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_events
  # before_filter :auto_add_pulbic_domain_for_user

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation, :current_password
    end
  end

  private
  def create_cart
    @cart = Cart.build_from_hash session[:cart]
    @cart_group = @cart.items.group_by(&:shop_id).map  do |q|
      {shop_id: q.first, items: q.second.each.map { |qn| qn }}
    end
  end

  def load_events
    if user_signed_in?
      @events = current_user.events.by_date
      @count_unread_notification = @events.unread.size
    end
  end

  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def params_create_order cart_shop, shop_order
    {user: current_user, total_pay: cart_shop.total_price,
      cart: cart_shop, shop: shop_order}
  end

  def delete_cart_item_shop cart, shop
    items = cart["items"].select{|item| item["shop_id"] == shop.id}
    if items.present?
      create_cart
      cart["items"] = cart["items"] - items
    end
  end

  def load_cart_shop shop_order
    cart_shop = @cart_group.detect {|shop| shop[:shop_id] == shop_order.id}
    Cart.new cart_shop[:items] if cart_shop.present?
  end

  def check_user_status_for_action
    if current_user.wait?
      flash[:danger] = t "information"
      redirect_to root_path
    end
  end

  def load_domain
    binding.pry
    if params[:domain_id] == Settings.not_find
      @domain = nil
    else
      @domain = if params[:domain_id]
        Domain.friendly.find params[:domain_id]
      else
        Domain.friendly.find params[:id]
      end
    end
  end

  def redirect_to_root_domain
    if (!user_signed_in?) || (!current_user.domains.include? @domain)
      redirect_to root_path
    end
  end

  def auto_add_pulbic_domain_for_user
    if user_signed_in? && !current_user.domains.present?
      domain = Domain.first
      create_data_for_domain current_user, domain
    end
  end

  def create_data_for_domain user, domain
    user_domain = UserDomain.new user_id: user.id, domain_id: domain.id
    if user_domain.save
      flash[:success] = t "save_domain_successfully"
    else
      flash[:danger] = t "can_not_add_account"
    end
  end

end
