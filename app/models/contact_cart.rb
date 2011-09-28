class ContactCart < ActiveRecord::Base
  include CohortModelExtensions

  has_and_belongs_to_many :contacts
  belongs_to :user


end
