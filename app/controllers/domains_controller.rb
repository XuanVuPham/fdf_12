class DomainsController < ApplicationController
  before_action :load_domain
  def show
    if user_signed_in? && @domain.present?
      redirect_to root_url(subdomain: @domain.subdomain)
    else
      if request.subdomains(0).first
        @domain = Domain.find_by subdomain: request.subdomains(0).first
        redirect_to root_url(subdomain: @domain.subdomain)
      else
        redirect_to root_url()
      end
    end
  end
end
