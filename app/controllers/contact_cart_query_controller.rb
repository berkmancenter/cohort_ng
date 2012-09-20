class ContactCartQueryController < BaseController

  def yours
    if current_user
      breadcrumbs.add('My Contact Lists', contact_cart_query_yours_path)
      @contact_carts = ContactCart.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?','owner','ContactCart', current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    end
    negotiate_list_query_response('contact_cart')
  end

  def your_private
    if current_user
      breadcrumbs.add('My Private Contact Lists', contact_cart_query_your_private_path)
      @contact_carts = ContactCart.joins(:accepted_roles => [:users]).paginate(:order => 'updated_at', :conditions => ['roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ? and global is true','owner','ContactCart', current_user.id], :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    end
    negotiate_list_query_response('contact_cart')
  end

  def all
    breadcrumbs.add('All Contact Lists', contact_cart_query_all_path)
    total_entries = ContactCart.all_available(current_user).length
    @contact_carts = ContactCart.all_available(current_user).paginate(:page => params[:page], :per_page => params[:per_page] || ContactCart.per_page, :total_entries => total_entries)
    negotiate_list_query_response('contact_cart')
  end
  
  def recent
    breadcrumbs.add('Recently Updated Contact Lists', contact_cart_query_recent_path)
    @contacts = ContactCart.all_available(current_user).paginate(:order => 'updated_at desc', :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    negotiate_list_query_response('contact_cart')
  end

  def new
    breadcrumbs.add('New Contact Lists', contact_cart_query_new_path)
    @contacts = ContactCart.all_available(current_user).paginate(:order => 'created_at desc', :page => params[:page], :per_page => params[:per_page] || ContactCart.per_page)
    negotiate_list_query_response('contact_cart')
  end

  def chooser
  end

end
