module TaggingExtensions
  def self.included(model)

    model.class_eval do
      #Instance Methods.

    end

    model.instance_eval do
#      taggable_contexts = TagContext.all(:conditions => {:object_tagged => model.to_s}).collect{|tc| tc.context.to_sym}

#      if taggable_contexts.blank?
#        to_class_eval = [:tags] 
#      end

      acts_as_taggable_on

      def autocomplete_for(context = :tags, query_term = nil)
        return [] if query_term.blank?
        self.find_by_sql(['select distinct(tags.name) from tags left join taggings on tags.id = taggings.tag_id where taggable_type = ? and context = ? and tags.name like ? order by tags.name',self.name,context.to_s,"#{query_term}%"]).collect{|t|t.name}
      end
    end

  end
end
