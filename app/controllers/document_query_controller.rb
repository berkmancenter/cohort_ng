class DocumentQueryController < BaseController

  def new
    @documents = Document.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Document.per_page)
    negotiate_list_query_response('document')
  end

  def recent
    @documents = Document.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Document.per_page)
    negotiate_list_query_response('document')
  end

  def yours
    if current_user
      @documents = Document.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Note', current_user.id], :page => params[:page], :per_page => params[:per_page] || Document.per_page)
    end
    negotiate_list_query_response('document')
  end

  def contact
    @documents = Document.paginate(:conditions => ['contact_id = ?', params[:id]], :order => 'created_at', :page => params[:page], :per_page => params[:per_page] || Document.per_page)
    respond_to do |format|
      format.js {
        render :partial => "shared/contact_document_list"
      }
      format.html {
        render :partial => "shared/contact_document_list", :layout => ! request.xhr? 
      }
    end
  end

end
