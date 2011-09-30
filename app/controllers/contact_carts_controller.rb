class ContactCartsController < BaseController

  def index
    @contact_carts = ContactCart.active
  end

  def all_contact_carts
  end

  def my_contact_carts
  end

  def my_private_contact_carts
  end



end
