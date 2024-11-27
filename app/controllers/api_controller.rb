class ApiController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token

  respond_to :json

  private

  def current_user
    @current_user ||= User.find(id: doorkeeper_token[:resource_owner_id]) if doorkeeper_token
  end
end
