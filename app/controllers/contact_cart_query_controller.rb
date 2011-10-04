class ContactCartQueryController < BaseController

  def yours
    if current_user
      @contact_carts = ContactCart.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','ContactCart', current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    end
    negotiate_list_query_response('contact_cart')
  end

  def your_private
    if current_user
      @contact_carts = ContactCart.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ? and global is true','owner','ContactCart', current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    end
    negotiate_list_query_response('contact_cart')
  end

  def all
    @contact_carts = ContactCart.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['(roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?) OR global is true','owner','ContactCart', (current_user.blank?) ? nil : current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    negotiate_list_query_response('contact_cart')
  end

end
