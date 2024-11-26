class SitePagesController < ApplicationController
  def getting_started
    @application = Doorkeeper::Application.find_by(name: "Moonrocks - web")
    @application = {
      uid: @application.uid,
      secret: @application.secret,
      name: @application.name
    }
    render "site_pages/getting_started"
  end

  def terms
    render "site_pages/terms"
  end
end
