class TagContextQueryController < ApplicationController

  def all
    @tag_contexts = TagContext.all
    respond_to do |format|
      format.js { render :template => 'tag_contexts/index', :layout => false }
      format.html { render :template => 'tag_contexts/index' }
    end
  end

end
