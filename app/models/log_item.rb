class LogItem < ActiveRecord::Base
  LOG_ITEM_TYPES = {'update' => 'Update', 'warning' => 'Warning', 'error' => 'Error', 'contact' => 'Contact'}

  validates_inclusion_of :log_item_type, :in => LOG_ITEM_TYPES.keys

  belongs_to :user, :validate => true
  belongs_to :contact, :validate => true

  def self.log_item_type_options_for_select
    options = []
    LOG_ITEM_TYPES.keys.each{|type|
      options << [LOG_ITEM_TYPES[type], type]
    }
    return options
  end
  
end
