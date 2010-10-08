class ContactQueryController < ApplicationController
  def recent
    @contacts = Contact.paginate(:order => 'updated_at', :page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.js { 
        render :partial => 'shared/contact_list', 
          :locals => {:title => 'Recent Contacts'} 
      }
      #TODO - Get this to render the layout. . .odd.
      format.html { 
        render :partial => 'shared/contact_list', 
          :locals => {:title => 'Recent Contacts'}
      }
    end
  end

  def new
    @contacts = Contact.paginate(:order => 'created_at', :page => params[:page], :per_page => params[:per_page])
  end

  def yours
  end

  def all
  end

  def todo
  end

end
