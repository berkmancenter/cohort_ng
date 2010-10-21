class Note < ActiveRecord::Base
  include CohortModelExtensions
  belongs_to :user
  belongs_to :contact

end
