class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => params[:per_page])
    render :partial => 'all_users'
  end

  def new
    @user = User.new
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end
  
  def create
    @user = User.new
    @user.email = params[:user][:email]
    @user.password = User.random_password
    
    respond_to do|format|
      if @user.save
        flash[:notice] = "Created that user"
        format.js {render :text => '', :layout => ! request.xhr? }
        format.html {render :text => '', :layout => ! request.xhr? }
      else
        format.js { render :text => "We couldn't add that user. <br />#{@user.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't add that user. <br />#{@user.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def destroy
    @user = User.find(params[:id])
    p "in here"
    if @user.destroy
      respond_to do|format|
        format.js { }
        format.html { render :layout => ! request.xhr? }
      end
    else

    end
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user] 
    respond_to do|format|
      if @user.save
        flash[:notice] = "Updated that user"
        format.js { render :text => nil }
        format.html {render :text => 'success', :layout => ! request.xhr?}
      else
        format.js { render :text => "We couldn't update that user. <br />#{@user.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { 
          if request.xhr?
            render :text => "We couldn't update that user. <br />#{@user.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => false
          else 
            render :template => 'user/new'
          end
        }
      end
    end
  end
end
