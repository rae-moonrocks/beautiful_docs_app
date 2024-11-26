class SitePagesController < ApplicationController
  def getting_started
    render "site_pages/getting_started"
  end

  def terms
    render "site_pages/terms"
  end
end
