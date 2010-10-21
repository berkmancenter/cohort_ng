class Contact < ActiveRecord::Base
  include CohortModelExtensions

  belongs_to :user
  
  has_many :addresses, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :log_items, :dependent => :destroy
  has_many :notes, :dependent => :destroy
   
end
