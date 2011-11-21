class Duplicate < ActiveRecord::Base
  include CohortModelExtensions
  belongs_to :user
  belongs_to :source_contact, :class => Contact
  belongs_to :contact

  def self.exact_name_matches
  end

  def self.approximate_name_matches
  end

  def self.approximate_email_matches
  end



end
