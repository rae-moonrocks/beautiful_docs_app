module Users
  class ApplicationsController < ApplicationController
    before_action :redirect_unauthorized_users
    def index
      @applications = Doorkeeper::Application.where(owner_id: current_user.id)
    end
    def show
      @application = Doorkeeper::Application.find_by(id: params[:id], owner_id: current_user.id)
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

    def create
      @application = Doorkeeper::Application.create(name: application_params[:name], redirect_uri: "", scopes: "", owner_id: current_user.id, owner_type: "User")
      if @application.save
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
