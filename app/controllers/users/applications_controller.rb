module Users
  class ApplicationsController < ApplicationController
    def show
      # make sure user is connected to app
      @application = Doorkeeper::Application.find(params[:id])
    end
    def new
      @application = Doorkeeper::Application.new
    end

    def create
      # make sure current user
      return render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
      @application = Doorkeeper::Application.create(name: application_params[:name], redirect_uri: "", scopes: "", owner_id: current_user.id, owner_type: "User")
      if @application.save
        redirect_to users_application_path(@application.id)
      else
        flash[:error] = @application.errors.full_messages.join(", ")
        render :new
      end
    end

    private

    def application_params
      params.require(:user_application).permit(:name)
    end
  end
end
