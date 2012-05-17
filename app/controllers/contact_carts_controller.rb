class ContactCartsController < BaseController

  def add_object
    @contact_cart = ContactCart.find_or_create_by_id(params[:id])
    unless @contact_cart
      # autovivify
      @contact_cart = ContactCart.create(:name => "Contact List created on #{Time.now.to_s(:compact_datetime)}", :global => true)
    end
    object_id = params[:object_id]

    contact_input = params[:object_type].constantize.find(params[:object_id])

    message = ''
    unless @contact_cart.contact_sources.collect{|cs| cs.contact_input}.include?(contact_input)
      ContactSource.create!(:contact_input => contact_input, :contact_cart => @contact_cart)
      message = 'Added that item. Cheers!'
    else
      message = 'That item was already in this contact list.'
    end
    respond_to do|format|
      format.js{ render :text => message }
      format.html{ render :text => message, :layout => ! request.xhr? }
    end
  rescue Exception => e
    respond_to do|format|
      format.js { render :text => "We couldn't add that item. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
      format.html { render :text => "We couldn't add that item. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
    end
  end

  def index
    breadcrumbs.add('All Contact Lists', contact_cart_path)
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
        current_user.has_role!(:owner, @contact_cart)
        current_user.has_role!(:creator, @contact_cart)
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
        current_user.has_role!(:editor, @contact_cart)
        flash[:notice] = "Updated that contact list"
        format.js { render :text => nil }
        format.html { render :text => "success", :layout => ! request.xhr?}
      else
        format.js { render :text => "We couldn't update that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { 
          if request.xhr?
            render :text => "We couldn't update that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => false 
          else 
            render :template => 'contact_cart/new'
          end
        }
      end
    end
  end

  def destroy
    @contact_cart = ContactCart.find(params[:id])
    respond_to do |format|
      if @contact_cart.destroy
        flash[:notice] = "Removed that contact list"
        format.js { render :text => nil }
        format.html { render :text => 'success', :layout => ! request.xhr? }
      else 
        flash[:notice] = "We couldn't remove that contact list"
        format.js { 
          render :text => "We couldn't remove that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity 
        }
        format.html { 
          render :text => "We couldn't remove that contact list. <br />#{@contact_cart.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => ! request.xhr? 
        }
      end
    end
  end

  def saved_search
    @contact_cart = ContactCart.find(params[:id])
    @contact_sources = @contact_cart.contact_sources.saved_search_input_sources.paginate(:page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('saved_search_contact_source')
  end
  
  def tags
    @contact_cart = ContactCart.find(params[:id])
    @contact_sources = @contact_cart.contact_sources.tag_input_sources.paginate(:page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('tag_contact_source')
  end

  def contacts
    @contact_cart = ContactCart.find(params[:id])
    @contact_sources = @contact_cart.contact_sources.contact_input_sources.paginate(:page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('contact_contact_source')
  end

end
