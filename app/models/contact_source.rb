class ContactSource < ActiveRecord::Base
  belongs_to :contact_cart

  scope :contact_input_sources, where(['contact_input_type = ?','Contact'])
  scope :tag_input_sources, where(['contact_input_type = ?','ActsAsTaggableOn::Tag'])
  scope :saved_search_input_sources, where(['contact_input_type = ?','SavedSearch'])

  belongs_to :contact_input, :polymorphic => :true
  validates_uniqueness_of :contact_cart_id, :scope => [:contact_input_type, :contact_input_id]

end
