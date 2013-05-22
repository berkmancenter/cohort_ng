class Note < ActiveRecord::Base
  include CohortModelExtensions
  acts_as_authorization_object

  #scope :to_dos, where('due_date is not null')
  scope :to_dos, where("note_type = 'task'")
  
  def self.per_page
    25
  end

  NOTE_TYPES = {'general' => 'General','task' => 'Task','about' => 'About'}
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
  
  def create_date_display
    (self.created_at.year == Time.now.year) ? self.created_at.to_s(:compact_date) :  self.created_at.to_s(:compact_date_with_year)
  end

  def to_s
    "#{note_type}, #{note}"
  end

end
