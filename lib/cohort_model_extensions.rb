module CohortModelExtensions

  def self.included(model)

    model.class_eval do
      # Instance methods go here.

      before_create {|c| c.created_at = c.updated_at = Time.now }
      before_save {|c| c.updated_at = Time.now }
      def is_true
        true
      end
    end

    model.instance_eval do
      #Class methods go here.

      def yuppers
        'yup'
      end
    end

  end
end
