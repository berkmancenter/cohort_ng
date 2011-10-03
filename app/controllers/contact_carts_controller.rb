class ContactCartsController < BaseController

  def index
    @contact_carts = ContactCart.active
  end

  def new
    @contact_cart = ContactCart.new
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def create
    @contact_cart = ContactCart.new
    @contact_cart.attributes = params[:contact_cart]
    respond_to do|format|
      if @contact_cart.save
        flash[:notice] = "Added that contact list"
        format.js { }
        format.html {render :text => '', :layout => request.xhr? }
      else
        format.js { render :text => "We couldn't add that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :new, :layout => ! request.xhr? }
      end
    end
  end

  def show
    # Need acl9. . 
    @contact_cart = ContactCart.find(params[:id])
    respond_to do |format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def edit
    @contact_cart = ContactCart.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'contact_carts/new' }
      format.html { render :template => 'contact_carts/new', :layout => ! request.xhr? }
    end
  end

  def update
    @contact_cart = ContactCart.find(params[:id])
    @contact_cart.attributes = params[:contact_cart]
    respond_to do|format|
      if @contact_cart.save
        flash[:notice] = "Updated that contact list"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index, :layout => ! request.xhr?}
      else
        format.js { render :text => "We couldn't update that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :edit, :layout => ! request.xhr? }
      end
    end
  end

  def destroy
    @contact_cart = ContactCart.find(params[:id])
    respond_to do |format|
      if @contact_cart.destroy
        flash[:notice] = "Removed that contact list"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index}
      else 
        flash[:notice] = "We couldn't remove that contact list"
        format.js { render :text => "We couldn't remove that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :index, :layout => ! request.xhr? }
      end
    end
  end

end
