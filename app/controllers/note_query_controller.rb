class NoteQueryController < BaseController
  def new
    @notes = Note.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note')
  end

  def recent
    @notes = Note.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def upcoming
    if current_user
      @notes = Note.to_dos.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Note', current_user.id], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    end
    negotiate_list_query_response('note')
  end

  def all_upcoming
    @notes = Note.to_dos.paginate(:order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note')
  end

  def yours
    if current_user
      @notes = Note.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Note', current_user.id], :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    end
    negotiate_list_query_response('note')
  end


  def contact
    @notes = Note.paginate(:conditions => ['contact_id = ?', params[:id]], :order => 'created_at', :page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js {
        render :partial => "shared/contact_note_list"
      }
      format.html {
        render :partial => "shared/contact_note_list", :layout => ! request.xhr? 
      }
    end
  end

  def priority
  end

end
