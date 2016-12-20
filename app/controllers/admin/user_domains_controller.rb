class Admin::UserDomainsController < ApplicationController
  def new
    user = User.find_by id: params[:user_id]
    domain = Domain.find_by id: params[:domain_id]
    unless user.domains.include? domain
      user_domain = UserDomain.new user_id: params[:user_id],
        domain_id: params[:domain_id]
      if user_domain.save
        flash[:success] = "Success"
      else
        flash[:danger] = "Not success"
      end
    end
    redirect_to :back
  end

  def destroy
    user_domain = UserDomain.find_by id: params[:id]
    if user_domain.destroy
      flash[:success] = "Delete domain success"
    end
    redirect_to :back
  end
end
