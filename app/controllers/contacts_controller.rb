class ContactsController < ApplicationController

  def index
    @contacts = Contact.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

  def autocomplete_for
    render :json => Contact.autocomplete_for(
      ((params[:context].blank?) ? :tags : params[:context]),
      params[:tag]
    )
  end

  def show
  end

  def new
    @contact = Contact.new
    respond_to do|format|
      format.js { render :layout => false}
      format.html {}
    end
  end

  def create
    @contact = Contact.new
    @contact.attributes = params[:contact]
    respond_to do|format|
      if @contact.save
        flash[:notice] = "Added that contact"
        format.js { render :layout => false}
        format.html {redirect_to :action => :index}
      else
        format.js { render :text => "We couldn't add that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :new }
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'contacts/new', :layout => false}
      format.html {}
    end
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.attributes = params[:contact]
    respond_to do|format|
      if @contact.save
        flash[:notice] = "Updated that contact"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index}
      else
        format.js { render :text => "We couldn't update that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.destroy
        flash[:notice] = "Removed that contact"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index}
      else 
        flash[:notice] = "We couldn't remove that contact"
        format.js { render :text => "We couldn't remove that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :index }
      end
    end
  end

end
