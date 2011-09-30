class ContactCartQueryController < BaseController

  def my
    if current_user
      @contact_carts = ContactCart.paginate(:order => 'updated_at', :conditions => {:user_id => current_user.id}, :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    end
    negotiate_list_query_response('contact_cart')
  end

  def all
    @contact_carts = ContactCart.paginate(:order => 'updated_at', :conditions => ['user_id = ? OR global is true', current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    negotiate_list_query_response('contact_cart')
  end

end
