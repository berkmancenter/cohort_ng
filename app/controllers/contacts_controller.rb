class ContactsController < ApplicationController

  def index
    @contacts = Contact.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
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

  def edit
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
        format.js { render :text => "We couldn't add that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity}
        format.html { render :action => :new }
      end
    end
  end

  def update
  end

  def destroy
  end

end
