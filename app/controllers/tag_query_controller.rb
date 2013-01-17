class TagQueryController < BaseController

  def search
    p "Tag Search"
    p params[:q]
    @tag_query = Sunspot.new_search(ActsAsTaggableOn::Tag)
    @tag_query.build do
      unless params[:q].blank?
        fulltext params[:q].strip
      end
      #text_fields{
      #  with(:hierarchical_name_for_indexing).starting_with(params[:q])
      #}
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end
    @tag_query.execute!
    p @tag_query
    @tags = @tag_query.results
    p @tags
    negotiate_list_query_response('tag')
  end

  def recent_taggings
    @taggings = ActsAsTaggableOn::Tagging.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || Note.per_page)
    negotiate_list_query_response('tagging')
  end

end
