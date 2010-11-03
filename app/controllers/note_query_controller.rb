class NoteQueryController < BaseController
  def new
    @notes = Note.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','New Notes')
  end

  def upcoming
    @notes = Note.paginate(:conditions => ['user_id = ?'], :order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_list_query_response('note','Upcoming Notes')
  end

  def priority
  end

end
