class ContactCart < ActiveRecord::Base
  include CohortModelExtensions

  scope :available, :conditions => {:global => true}

  has_and_belongs_to_many :contacts
  belongs_to :user


end
