class NotesController < BaseController

  def show
    @note = Note.find(params[:id])
    respond_to do |format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def new
    @note = Note.new(:contact_id => params[:contact_id])
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def create
    @note = Note.new
    @note.attributes = params[:note]
    respond_to do|format|
      if @note.save
        current_user.has_role!(:owner, @note)
        current_user.has_role!(:creator, @note)
        flash[:notice] = "Added that note"
        format.js { render :text => ''}
        format.html { render :text => '', :layout => ! request.xhr? }
      else
        format.js { render :text => "We couldn't add that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't add that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => ! request.xhr? }
      end
    end
  end

  def edit
    @note = Note.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'notes/new' }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def update
    @note = Note.find(params[:id])
    @note.attributes = params[:note]
    respond_to do|format|
      if @note.save
        current_user.has_role!(:editor, @note)
        flash[:notice] = "Updated that note"
        format.js { render :text => ''}
        format.html { render :text => '', :layout => ! request.xhr? }
      else
        format.js { render :text => "We couldn't update that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't update that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => ! request.xhr? }
      end
    end
  end

  def destroy
    @note = Note.find(params[:id])
    respond_to do |format|
      if @note.destroy
        flash[:notice] = "Removed that note"
        format.js { render :text => nil }
        format.html {render :text => '', :layout => ! request.xhr? }
      else 
        flash[:notice] = "We couldn't remove that note"
        format.js { render :text => "We couldn't remove that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't remove that note. <br />#{@note.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => ! request.xhr? }
      end
    end
  end

end
