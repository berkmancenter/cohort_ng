class ContactSource < ActiveRecord::Base
  belongs_to :contact_cart

  belongs_to :contact_input, :polymorphic => :true
  validates_uniqueness_of :contact_cart_id, :scope => [:contact_input_type, :contact_input_id]
end
