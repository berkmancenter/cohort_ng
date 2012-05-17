class ContactCart < ActiveRecord::Base
  include CohortModelExtensions
  acts_as_authorization_object

  scope :all_available, 
    lambda{|current_user| 
    select('DISTINCT contact_carts.*').joins(:accepted_roles => [:users]).where(['(roles.name = ? and roles.authorizable_type = ? and roles_users.user_id = ?) OR global is true','owner','ContactCart', ((current_user.blank?) ? nil : current_user.id) ]).order('updated_at')}

  def self.per_page
    25
  end

  has_many :contact_sources, :dependent => :destroy

  scope :available, :conditions => {:global => true}

  def contacts
    contact_sources.collect{|cs| cs.contact_input.contacts}.flatten.uniq
  end

  def to_s
    "#{name}"
  end

  def active_contact_input_types
    self.contact_sources.select(:contact_input_type).group(:contact_input_type).collect{|ci| ci.contact_input_type}
  end

end
