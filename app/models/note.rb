class Note < ActiveRecord::Base
  include CohortModelExtensions
  
  def self.per_page
    25
  end

  NOTE_TYPES = {'general' => 'General', 'followup' => 'Follow Up','call' => 'Phone Call'}
  belongs_to :user, :validate => true
  belongs_to :contact, :validate => true
  validates_inclusion_of :note_type, :in => NOTE_TYPES.keys
  validates_numericality_of :priority, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :allow_nil => true

  def self.note_type_options_for_select
    options = []
    NOTE_TYPES.keys.each{|type|
      options << [NOTE_TYPES[type], type]
    }
    return options
  end

  def due_date_display
    (self.due_date.year == Time.now.year) ? self.due_date.to_s(:compact_date) :  self.due_date.to_s(:compact_date_with_year)
  end


end
