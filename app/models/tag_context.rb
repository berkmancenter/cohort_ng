class TagContext < ActiveRecord::Base
  include CohortModelExtensions
  TAGGABLE_MODELS = ['Contact', 'Note']

  scope :on_contacts, :conditions => {:object_tagged => 'Contact'}, :order => :position

  validates_format_of :context, :with => /^[a-z\d_]+$/i

  # Must be unique for each object tagged.
  validates_uniqueness_of :context, :scope => :object_tagged

  def to_s
    "#{name}"
  end

end