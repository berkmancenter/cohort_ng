module CohortModelExtensions

  def self.included(model)
    model.class_eval do
      # Instance methods go here.

      validate do |rec|
        # Validate text and string column lengths automatically, and for existence.

        to_validate = rec.class.columns.reject{|col| ! [:string,:text].include?(col.type)}
        to_validate.each do|val_col|

          # don't apply the checks to carrierwave columns, this causes "limit exceeded" issues.
          next if val_col.name == 'file_attachment'

          validates_length_of val_col.name.to_sym, :maximum => val_col.limit, :allow_blank => val_col.null
          if ! val_col.null
            validates_presence_of val_col.name.to_sym
          end

        end
      end

      def check_if_deleteable
        if self.respond_to?(:deleteable) && self.deleteable == false
          self.errors.add_to_base("This #{self.class.to_s.downcase} can't be deleted.")
          return false
        end
      end

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
