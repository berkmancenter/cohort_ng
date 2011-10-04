class DocumentsController < ApplicationController

  def new
    @document = Document.new(:contact_id => params[:contact_id])
    respond_to do|format|
      format.js { }
      format.html { render :layout => ! request.xhr? }
    end
  end

  def create
    @document = Document.new
    @document.attributes = params[:document]
    @document.user = current_user
    respond_to do|format|
      if @document.save
        current_user.has_role!(:owner, @document)
        current_user.has_role!(:creator, @document)
        flash[:notice] = "Added that document"
        format.js { render :text => ''}
        format.html {redirect_to params[:_redirect]}
      else
        format.js { render :text => "We couldn't add that document. <br />#{@document.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :new, :layout => ! request.xhr? }
      end
    end
  end

  def edit
    @document = Document.find(params[:id])
    respond_to do|format|
      format.js { render :template => 'documents/new' }
      format.html { render :template => 'documents/new' , :layout => ! request.xhr? }
    end
  end

  def update
    @document = Document.find(params[:id])
    @document.attributes = params[:document]
    respond_to do|format|
      if @document.save
        current_user.has_role!(:editor, @document)
        flash[:notice] = %Q|Updated the document "#{@document.name}" on "#{@document.contact}"|
        format.js { render :text => nil }
        format.html {redirect_to params[:_redirect]}
      else
        format.js { render :text => "We couldn't update that document. <br />#{@document.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :edit, :layout => ! request.xhr? }
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    respond_to do |format|
      if @document.destroy
        flash[:notice] = "Removed that document"
        format.js { render :text => nil }
        format.html {render :text => '', :layout => ! request.xhr?}
      else 
        flash[:notice] = "We couldn't remove that document"
        format.js { render :text => "We couldn't remove that document. <br />#{@document.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :text => "We couldn't remove that document. <br />#{@document.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity, :layout => request.xhr? }
      end
    end
  end

  def show
  end

end
