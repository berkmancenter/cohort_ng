class ContactCart < ActiveRecord::Base
  include CohortModelExtensions
  acts_as_authorization_object

  def self.per_page
    50
  end

  scope :available, :conditions => {:global => true}

  has_and_belongs_to_many :contacts

  def to_s
    "#{name}"
  end


end
