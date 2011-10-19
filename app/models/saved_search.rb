class SavedSearch < ActiveRecord::Base
  has_many :saved_search_runs, :dependent => :destroy

  validates_format_of :name, :with => /^[a-z\d\-\, ]+$/i, :message => 'should contain only letters, numbers, spaces, hyphens and commas.'
end
