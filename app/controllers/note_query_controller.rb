class NoteQueryController < BaseController
  def new
    @notes = Note.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','New Notes')
  end

  def upcoming
    @notes = Note.paginate(:conditions => ['user_id = ?'], :order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','Your todos')
  end

  def all_upcoming
    @notes = Note.paginate(:order => 'due_date desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','All todos')
  end

  def priority
  end

end
