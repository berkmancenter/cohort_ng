class TagContext < ActiveRecord::Base
  include CohortModelExtensions
  TAGGABLE_MODELS = [Contact, Note]

#  def to_param
#    "#{id}-#{name}"
#  end

end
