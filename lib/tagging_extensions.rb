module TaggingExtensions
  def self.included(model)

    model.class_eval do
      #Instance Methods.

    end

    model.instance_eval do
      def autocomplete_tags(query_term = nil, context = :tags)
        return [] if query_term.blank?
        ids = ActsAsTaggableOn::Tag.all(:conditions => ['name ' + ((connection.adapter_name == 'PostgreSQL') ? 'ilike' : 'like') + ' ?', "#{query_term.downcase}%"]).collect{|t|t.hierarchical_name}
      end
    end

  end
end
