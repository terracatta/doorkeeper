module Doorkeeper
  class ApplicationsController < Doorkeeper::ApplicationController
    respond_to :html

    before_filter :authenticate_admin!

    def index
      @applications = Doorkeeper.client.all
    end

    def new
      @application = Doorkeeper.client.new
    end

    def create
      @application = Doorkeeper.client.new(params[:application])
      Doorkeeper::OAuth::Client.register(params[:client])
      if @application.save
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
        respond_with [:oauth, @application]
      else
        render :new
      end
    end

    def show
      @application = Doorkeeper.client.find(params[:id])
    end

    def edit
      @application = Doorkeeper.client.find(params[:id])
    end

    def update
      @application = Doorkeeper.client.find(params[:id])
      if @application.update_attributes(params[:application])
        flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :update])
        respond_with [:oauth, @application]
      else
        render :edit
      end
    end

    def destroy
      @application = Doorkeeper.client.find(params[:id])
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :destroy]) if @application.destroy
      redirect_to oauth_applications_url
    end
  end
end
