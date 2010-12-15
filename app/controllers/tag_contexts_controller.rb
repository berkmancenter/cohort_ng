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

  def new
    @tag_context = TagContext.new
    respond_to do|format|
      format.js { render :layout => false}
      format.html {}
    end
  end

  def create
    @tag_context = TagContext.new
    @tag_context.attributes = params[:tag_context]
    respond_to do|format|
      if @tag_context.save
        flash[:notice] = "Added that tag context"
        format.js { render :text => '' }
        format.html {redirect_to :action => :index}
      else
        format.js { render :text => "We couldn't add that tag context. <br />#{@tag_context.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :new }
      end
    end
  end

  def edit
    @tag_context = TagContext.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'tag_contexts/new', :layout => false}
      format.html {}
    end
  end

  def update
    @tag_context = TagContext.find(params[:id])
    @tag_context.attributes = params[:tag_context]
    respond_to do|format|
      if @tag_context.save
        flash[:notice] = "Updated that tag context"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index}
      else
        format.js { render :text => "We couldn't update that tag context. <br />#{@tag_context.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :edit }
      end
    end
  end

  def destroy
    @tag_context = TagContext.find(params[:id])
    respond_to do |format|
      if @tag_context.destroy
        flash[:notice] = "Removed that tag context"
        format.js { render :text => nil }
        format.html {redirect_to :action => :index}
      else 
        flash[:notice] = "We couldn't remove that tag context"
        format.js { render :text => "We couldn't remove that tag context. <br />#{@tag_context.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :index }
      end
    end
  end

end
