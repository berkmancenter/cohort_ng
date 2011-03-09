class ContactQueryController < BaseController

  def autocomplete_tags
    @tags = Sunspot.new_search(ActsAsTaggableOn::Tag)
    @tags.build do
      text_fields{
        with(:hierarchical_name_for_indexing).starting_with(params[:tag])
      }
    end
    @tags.execute!
    render :json => @tags.hits.collect{|t| t.stored(:hierarchical_name_for_indexing)}.flatten
  end

  def search
    @contacts = Sunspot.new_search(Contact)
    @contacts.build do
      unless params[:q].blank?
        keywords params[:q]
      end
      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || nil
    end
    @contacts.execute!
    respond_to do |format|
      format.html 
      format.js { render :json => @contacts }
      format.xml  { render :xml => @contacts }
    end
  end

  def recent
    @contacts = Contact.active.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
    negotiate_list_query_response('contact','Recent Updates')
  end

  def new
    @contacts = Contact.active.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
    negotiate_list_query_response('contact','New Contacts')
  end

  def yours
    if current_user
      @contacts = Contact.active.paginate(:order => 'updated_at', :conditions => {:user_id => current_user.id}, :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
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
