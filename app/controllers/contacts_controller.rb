class ContactsController < BaseController

  def index
    @contacts = Contact.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def show
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def new
    @contact = Contact.new
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def create
    @contact = Contact.new
    params[:contact].delete(:hierarchical_tags_for_edit)
    @contact.attributes = params[:contact]
    @contact.hierarchical_tag_list = params[:contact][:hierarchical_tag_list]
    respond_to do|format|
      if @contact.save
        current_user.has_role!(:owner, @contact)
        current_user.has_role!(:creator, @contact)
        flash[:notice] = "Created that contact"
        format.js {render :text => '', :layout => ! request.xhr? }
        format.html {render :text => '', :layout => ! request.xhr? }
      else
        format.js { render :text => "We couldn't add that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't add that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @contact = Contact.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'contacts/new' }
      format.html { render :template => 'contacts/new', :layout => ! request.xhr? }
    end
  end

  def update
    @contact = Contact.find(params[:id])
    params[:contact].delete(:hierarchical_tags_for_edit)
    @contact.attributes = params[:contact]
    respond_to do|format|
      if @contact.save
        current_user.has_role!(:editor, @contact)
        flash[:notice] = "Updated that contact"
        format.js { render :text => nil }
        format.html {render :text => 'success', :layout => ! request.xhr?}
      else
        format.js { render :text => "We couldn't update that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { 
          if request.xhr?
            render :text => "We couldn't update that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => false
          else 
            render :template => 'contact/new'
          end
        }
      end
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.destroy
        flash[:notice] = "Removed that contact"
        format.js { render :text => nil }
        format.html { render :text => nil, :layout => ! request.xhr? }
      else 
        flash[:notice] = "We couldn't remove that contact"
        format.js { render :text => "We couldn't remove that contact. <br />#{@contact.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :index, :layout => ! request.xhr? }
      end
    end
  end

  def quick
    render :partial => "shared/forms/contact_quick"
  end

end
