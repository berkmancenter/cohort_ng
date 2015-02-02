class NoteQueryController < BaseController
  def new
    breadcrumbs.add('New Notes', note_query_new_path)
    @notes = Note.paginate(:conditions => ["note_type <> 'task'"], :order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def recent
    breadcrumbs.add('Recently Updated Notes', note_query_recent_path)
    @notes = Note.paginate(:conditions => ["note_type <> 'task'"], :order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def upcoming
    if current_user
      breadcrumbs.add('My Tasks', note_query_upcoming_path)
      @notes = Note.to_dos.joins(:accepted_roles => [:users]).paginate(:conditions => ["roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ? and note_type = ? and (complete is false or complete is NULL)",'owner','Note', current_user.id,'task'], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
      @task = true
      @complete = Note.to_dos.joins(:accepted_roles => [:users]).paginate(:conditions => ["roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ? and note_type = ? and complete is true",'owner','Note', current_user.id,'task'], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    end
    negotiate_list_query_response('note')
  end

  def all_upcoming
    breadcrumbs.add('All Tasks', note_query_all_upcoming_path)
    @notes = Note.to_dos.paginate(:conditions => ["note_type = ? and (complete is false or complete is NULL)",'task'], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    @task = true
    @complete = Note.to_dos.paginate(:conditions => ["note_type = ? and complete is true",'task'], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('note')
  end

  def yours
    if current_user
      breadcrumbs.add('My Notes', note_query_yours_path)
      @notes = Note.joins(:accepted_roles => [:users]).paginate(:conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ? and notes.note_type <> ?','owner','Note', current_user.id, 'task'], :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    end
    negotiate_list_query_response('note')
  end


  def contact
    breadcrumbs.add('Notes on this contact', note_query_contact_path(params[:id]))
    @notes = Note.paginate(:conditions => ['contact_id = ? and note_type <> ?', params[:id], 'task'], :order => 'created_at', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    respond_to do |format|
      format.js {
        render :partial => "shared/contact_note_list"
      }
      format.html {
        render :partial => "shared/contact_note_list", :layout => ! request.xhr? 
      }
    end
  end
  
  def contact_tasks
    breadcrumbs.add('Tasks on this contact', note_query_contact_tasks_path(params[:id]))
    @notes = Note.paginate(:conditions => ['contact_id = ? and note_type = ?', params[:id], 'task'], :order => 'created_at', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
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
