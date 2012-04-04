class NoteQueryController < BaseController
  def new
    breadcrumbs.add('New Notes', note_query_new_path)
    @notes = Note.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def recent
    breadcrumbs.add('Recently Updated Notes', note_query_recent_path)
    @notes = Note.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def upcoming
    if current_user
      breadcrumbs.add('My Tasks', note_query_upcoming_path)
      @notes = Note.to_dos.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Note', current_user.id], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    end
    negotiate_list_query_response('note')
  end

  def all_upcoming
    breadcrumbs.add('All Tasks', note_query_all_upcoming_path)
    @notes = Note.to_dos.paginate(:order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def yours
    if current_user
      breadcrumbs.add('My Notes', note_query_yours_path)
      @notes = Note.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','Note', current_user.id], :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    end
    negotiate_list_query_response('note')
  end


  def contact
    breadcrumbs.add('Notes on this contact', note_query_contact_path(params[:id]))
    @notes = Note.paginate(:conditions => ['contact_id = ?', params[:id]], :order => 'created_at', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
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
