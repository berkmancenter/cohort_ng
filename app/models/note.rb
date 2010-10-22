class Note < ActiveRecord::Base
  include CohortModelExtensions

  NOTE_TYPES = {'general' => 'General', 'followup' => 'Follow Up'}
  belongs_to :user, :validate => true
  belongs_to :contact, :validate => true
  validates_inclusion_of :note_type, :in => NOTE_TYPES.keys

  def self.note_type_options_for_select
    options = []
    NOTE_TYPES.keys.each{|type|
      options << [NOTE_TYPES[type], type]
    }
    return options
  end


end
