class TagContextsController < BaseController

  def index
    @tag_contexts = TagContext.all
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

  def show
    @tag_context = TagContext.find(params[:id])
    respond_to do |format|
      format.js { render :layout => false }
      format.html { }
    end
  end

end
