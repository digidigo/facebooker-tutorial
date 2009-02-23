class FacebookerAppsController < ApplicationController
  # GET /facebooker_apps
  # GET /facebooker_apps.xml
  
  before_filter :setup
  before_filter :setup_db_facebook_user
  ensure_application_is_installed_by_facebook_user [:only => ["new", "edit", "create"]]
  def setup
    @title = "Facebooker Gallery"
    
  end
  
  def index
    if( is_admin() )
          @facebooker_apps = FacebookerApp.find(:all)
    else
          @facebooker_apps = FacebookerApp.find(:all, :conditions => ["approved = ?", true])
    end
  end

  # GET /facebooker_apps/1
  # GET /facebooker_apps/1.xml
  def show
    @facebooker_app = FacebookerApp.find(params[:id])
  end

  # GET /facebooker_apps/new
  # GET /facebooker_apps/new.xml
  def new
    @facebooker_app = FacebookerApp.new   
  end

  # GET /facebooker_apps/1/edit
  def edit
     @facebooker_app = FacebookerApp.find(params[:id])
     if( @facebooker_app.uid == @facebook_session.user.id rescue false)
     render :action => "new"
     else
       flash[:error] = "You don't have permission to edit this record."
     end
  end

  # POST /facebooker_apps
  # POST /facebooker_apps.xml
  def create
    @facebooker_app = FacebookerApp.new(params[:facebookerapp])
    @facebooker_app.uid = @facebook_session.user.id

      if @facebooker_app.save
        flash[:notice] = 'FacebookerApp was successfully created.'
        redirect_to(@facebooker_app) 
      else
         render :action => "new"
      end

  end

  # PUT /facebooker_apps/1
  # PUT /facebooker_apps/1.xml
  def update
    @facebooker_app = FacebookerApp.find(params[:id])

      if @facebooker_app.update_attributes(params[:facebookerapp])
        flash[:notice] = 'FacebookerApp was successfully updated.'
        redirect_to(@facebooker_app)
      else
        render :action => "edit" 
      end

  end

  def approve
    render :nothing => true and return unless is_admin
    @facebooker_app = FacebookerApp.find(params[:id])
    @facebooker_app.approved = true
    @facebooker_app.save!
    render :partial => "approve_remove_tag", :locals =>  {:facebooker_app => @facebooker_app   }
  end
  # DELETE /facebooker_apps/1
  # DELETE /facebooker_apps/1.xml
  def delete
    render :nothing => true and return unless is_admin
    @facebooker_app = FacebookerApp.find(params[:id])
    @facebooker_app.destroy

    render :text => "Deleted #{@facebooker_app.name}"
  end
end
