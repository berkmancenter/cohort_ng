class ContactQueryController < ApplicationController

  def recent
    @contacts = Contact.paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_contact_list_response('Recent Updates')
  end

  def new
    @contacts = Contact.paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page])
    negotiate_contact_list_response('New Contacts')
  end

  def yours
    if current_user
      @contacts = Contact.paginate(:order => 'updated_at', :conditions => {:user_id => current_user.id}, :page => params[:page], :per_page => params[:per_page])
    end
    negotiate_contact_list_response('Your contacts')
  end

  def all
  end

  def todo
    @contacts = Contact.paginate(:order => 'updated_at', :conditions => {:user_id => nil}, :page => params[:page], :per_page => params[:per_page])
    negotiate_contact_list_response('Your contacts')
  end

  private

  def negotiate_contact_list_response(title = 'Recent Contacts')
    respond_to do |format|
      format.js { 
        render :partial => 'shared/contact_list', 
        :locals => {:title => title} 
      }
      #TODO - Get this to render the layout. . .odd.
      format.html { 
        render :partial => 'shared/contact_list', 
        :locals => {:title => title}
      }
    end
  end

end
