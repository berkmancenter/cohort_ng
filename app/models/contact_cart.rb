class ContactCart < ActiveRecord::Base
  include CohortModelExtensions

  def self.per_page
    50
  end

  scope :available, :conditions => {:global => true}

  has_and_belongs_to_many :contacts
  belongs_to :user

  def to_s
    "#{name}"
  end


end
