class TagQueryController < BaseController

  def tag

    @tag_ids = ActsAsTaggableOn::Tag.find(params[:id]).children.collect{|c| c.id}
    @tag_ids << params[:id].to_i

    logger.warn("Tag ids: #{@tag_ids.inspect}")
    @contact_query = Sunspot.new_search(Contact)
    @contact_query.build do
      with(:tag_ids).any_of @tag_ids
      with :active, true
      with :deleted, false
      paginate :page => params[:page], :per_page => cookies[:per_page] || Contact.per_page
    end
    @contact_query.execute!

    @contacts = @contact_query.results
    negotiate_list_query_response('contact','')
  end

  def search
  end

end
