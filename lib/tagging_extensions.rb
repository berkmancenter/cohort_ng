module TaggingExtensions

  def self.included(model)
    model.class_eval do
      #Instance Methods.
    end

    model.instance_eval do
      #Class methods
    end
  end

end
