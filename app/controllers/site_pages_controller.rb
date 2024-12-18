class SitePagesController < ApplicationController
  def home
    render "site_pages/home"
  end

  def contact
    render "site_pages/contact"
  end
  def getting_started
    render "site_pages/getting_started"
  end

  def terms
    render "site_pages/terms"
  end
end
