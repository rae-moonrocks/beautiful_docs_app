module Users
  class ApplicationsController < ApplicationController
    before_action :redirect_unauthorized_users
    include DoorkeeperRegisterable
    def index
      @applications = Doorkeeper::Application.where(owner_id: current_user.id)
    end
    def show
      @application = Doorkeeper::Application.find_by(id: params[:id], owner_id: current_user.id)
      @access_token = Doorkeeper::AccessToken.where(resource_owner_id: current_user.id, application_id: @application.id, revoked_at: nil).order("id DESC").first
      if @application
        render :show
      else
        flash[:error] = "Application not found"
        redirect_to users_applications_path
      end
    end
    def new
      @application = Doorkeeper::Application.new
    end

    def refresh_token
      @application = Doorkeeper::Application.find_by(id: params[:id], owner_id: current_user.id)
      if token = Doorkeeper::AccessToken.where(resource_owner_id: current_user.id, application_id: @application.id)
        token.each { |t| t.revoke }
        @user_access_token = create_access_token(current_user, @application)
        flash[:notice] = "Token refreshed successfully"
        redirect_to users_application_path(@application.id)
      else
        flash[:error] = "Token not found"
        redirect_to users_application_path(@application.id)
      end
    end

    def create
      @application = Doorkeeper::Application.create(name: application_params[:name], redirect_uri: "", scopes: "", owner_id: current_user.id, owner_type: "User")
      if @application.save
        @user_access_token = create_access_token(current_user, @application)
        redirect_to users_application_path(@application.id)
      else
        flash[:error] = @application.errors.full_messages.join(", ")
        render :new
      end
    end

    private

    def redirect_unauthorized_users
      redirect_to root_path unless current_user
    end

    def application_params
      params.require(:user_application).permit(:name)
    end
  end
end
