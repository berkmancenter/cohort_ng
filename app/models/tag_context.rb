class TagContext < ActiveRecord::Base
  include CohortModelExtensions
  TAGGABLE_MODELS = [Contact, Note]
end
