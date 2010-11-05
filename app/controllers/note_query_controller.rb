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

  def priority
  end

end
