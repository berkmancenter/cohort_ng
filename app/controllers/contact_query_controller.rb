class ContactQueryController < BaseController
#  protect_from_forgery :except => [:autocomplete_tags, :autofill]
  #

  def similar_names
    @contact = Contact.find(params[:id])

    @contact_query = Sunspot.more_like_this(@contact,Contact) do
      fields :first_name_downcase, :last_name_downcase
      minimum_word_length (params[:mwl].blank?) ? 6 : params[:mwl]
      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end

    @contact_query.execute!
    @contacts = @contact_query.results
    negotiate_list_query_response('duplicate')
  end

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

  def tag_contacts_by_name
    breadcrumbs.add('Contacts with this tag', contact_query_recent_path)
    @contact_query = Sunspot.new_search(Contact)
    @contact_query.build do
      with(:hierarchical_tags).starting_with(params[:id])
      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end
    @contact_query.execute!
    @contacts = @contact_query.results
    negotiate_list_query_response('contact')
  end

  def tag_contacts
    breadcrumbs.add('Contacts with this tag', contact_query_recent_path)
    tag_id = params[:id]

    @tag = ActsAsTaggableOn::Tag.find(tag_id)
    tag_ids = [@tag.id]
    @tag.descendants.each do|t|
      tag_ids << t.id
    end

    # logger.warn("Tag ids: #{tag_ids.inspect}")
    @contact_query = Sunspot.new_search(Contact)
    @contact_query.build do
      with(:tag_ids).any_of tag_ids
      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end
    @contact_query.execute!
    @contacts = @contact_query.results
    negotiate_list_query_response('contact')
  end

  def search
    breadcrumbs.add('Contact Search', contact_query_recent_path)
    unless params[:q].blank?
      @contact_query = Sunspot.new_search(Contact)
      @contact_query.build do
        unless params[:q].blank?
          keywords params[:q]
        end
        with :active, true
        with :deleted, false
        paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
      end
      @contact_query.execute!
    else
      @contact_query = nil
    end
    respond_to do |format|
      format.html {
        if request.xhr?
          render :partial => 'shared/contact_search_results', :locals => {:contact_query => @contact_query} 
        else 
          render 
        end
      }
      format.js { render :layout => ! request.xhr? }
      format.xml  { render :xml => @contact_query.results }
    end
  end

  def recent
    breadcrumbs.add('Recently Updated Contacts', contact_query_recent_path)
    @contacts = Contact.active.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
    negotiate_list_query_response('contact')
  end

  def new
    breadcrumbs.add('New Contacts', contact_query_new_path)
    @contacts = Contact.active.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
    negotiate_list_query_response('contact')
  end

  def yours
    if current_user
      breadcrumbs.add('My Contacts', contact_query_yours_path)
      @contacts = Contact.active.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Contact', current_user.id], :page => params[:page], :per_page => params[:per_page] || Contact.per_page)
    end
    negotiate_list_query_response('contact')
  end

  def all
  end

  def autofill
    #TODO - implement sunspot
    @contacts = Contact.active.paginate(:conditions => ['first_name = ? or last_name = ?', params[:q], params[:q]])
    render :json => @contacts
  end

end
