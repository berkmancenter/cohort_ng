class TagQueryController < BaseController

  def search
  end

  def recent_taggings
    @taggings = ActsAsTaggableOn::Tagging.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('tagging')

  end

end
