# ActsAsFreetaggable
module Cohort
  module ActsAsFreetaggable
    def self.included(model)
#      klass.extend(ClassMethods)
      model.instance_eval do
        def acts_as_freetaggable(options={})
          klass = self.to_s.pluralize.underscore.to_sym
#          Tag.class_eval do
#            has_many :freetaggables, :through => :taggings
#          end
          self.class_eval do
            has_ancestry
            has_many :taggings, :as => :freetaggable, :dependent => :destroy
            has_many :tags, :through => :taggings
          end
        end
      end
    end
  end
end
