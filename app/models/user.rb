class User < ActiveRecord::Base
  include CohortModelExtensions

  acts_as_authentic
  has_many :notes, :dependent => :destroy
  has_many :log_items, :dependent => :destroy

  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates_uniqueness_of :login

end
