class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # def default_url_options
  #   if Rails.env.production?
  #     { host: "https://beautiful-docs-app.onrender.com" }
  #   else
  #   #  "http://#{ENV.fetch('HOST', 'localhost')}:#{ENV.fetch('PORT', '3000')}"
  #    { host: "localhost", port: 3000 }
  #   end
  # end
end
