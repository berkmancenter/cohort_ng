class ContactQueryController < BaseController

  def recent
    @contacts = Contact.active.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('contact','Recent Updates')
  end

  def new
    @contacts = Contact.active.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('contact','New Contacts')
  end

  def yours
    if current_user
      @contacts = Contact.active.paginate(:order => 'updated_at', :conditions => {:user_id => current_user.id}, :page => params[:page], :per_page => params[:per_page])
    end
    negotiate_list_query_response('contact','Your contacts')
  end

  def all
  end

  def autofill
    #TODO - implement sunspot
    @contacts = Contact.active.paginate(:conditions => ['first_name = ? or last_name = ?', params[:q], params[:q]])
    render :json => @contacts
  end

end
