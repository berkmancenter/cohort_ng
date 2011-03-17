class NoteQueryController < BaseController
  def new
    @notes = Note.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','New Notes')
  end

  def upcoming
    @notes = Note.paginate(:conditions => ['user_id = ?',current_user], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','Your to-dos')
  end

  def all_upcoming
    @notes = Note.paginate(:order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','All to-dos')
  end

  def contact
    @notes = Note.paginate(:conditions => ['contact_id = ?', params[:id]], :order => 'created_at', :page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js {
        render :partial => "shared/contact_note_list" 
      }
      format.html {
        render :partial => "shared/contact_note_list", :layout => true 
      }
    end
  end

  def priority
  end

end
