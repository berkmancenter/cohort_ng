class ContactSourcesController < BaseController

  #TODO - needs acl9

  def destroy
    @contact_source = ContactSource.find(params[:id])
    respond_to do |format|
      if @contact_source.destroy
        flash[:notice] = "Removed that contact from this list."
        format.js { render :text => nil }
        format.html { render :text => nil, :layout => ! request.xhr? }
      else 
        flash[:notice] = "We couldn't remove that contact from this list."
        format.js { render :text => "We couldn't remove that contact_source. <br />#{@contact_source.errors.full_messages.join('<br/>')}", :status => :unprocessable_entity }
        format.html { render :action => :index, :layout => ! request.xhr? }
      end
    end
  end

end
