class NotesController < BaseController

  def index
    breadcrumbs.add('Notes', notes_path)
  end
  
  def tasks
    breadcrumbs.add('Tasks', tasks_notes_path)
  end

  def show
    breadcrumbs.add('Note', note_path(params[:id]))
    @note = Note.find(params[:id])
    @role = Role.find(:first, :conditions=>{:name => 'owner', :authorizable_type => 'Note', :authorizable_id => @note.id})
    unless @role.nil?
      @owners = @role.users
    end
    respond_to do |format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def new
    @note = Note.new(:contact_id => params[:contact_id], :note_type => params[:type])
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
        if params[:owner] == "" || params[:owner].nil?
          current_user.has_role!(:owner, @note)
          current_user.has_role!(:creator, @note)
        else
          User.find(params[:owner].to_i).has_role!(:owner, @note)  
          current_user.has_role!(:creator, @note)
        end  
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
    @role = Role.find(:first, :conditions=>{:name => 'owner', :authorizable_type => 'Note', :authorizable_id => @note.id})
    unless @role.nil?
      @owners = @role.users
    end  
    
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
        if params[:owner] == "" || params[:owner].nil?
          current_user.has_role!(:editor, @note)
        else
          User.find(params[:owner].to_i).has_role!(:owner, @note)  
          current_user.has_role!(:editor, @note)
        end 
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
