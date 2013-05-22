# need csv from standard lib for importing
require 'csv'

Formtastic::SemanticFormBuilder.priority_countries = ['US','GB','CA']
Time::DATE_FORMATS[:day_and_hour] = "%j %H"
Time::DATE_FORMATS[:compact_datetime] = '%b %d, %I:%M%p'
Time::DATE_FORMATS[:compact_date_with_year] = '%b %d, %Y'
Time::DATE_FORMATS[:compact_date] = '%b %d'
PRODUCTION_HOST_NAME = 'cohort.dev.berkmancenter.org'

CohortNg::Application.config.organization_root_tag = ActsAsTaggableOn::Tag.where(:ancestry => nil, :name => "Organizations").first

ActsAsTaggableOn::Tag.class_eval{
  def contacts
    self.taggings.collect{|t| t.taggable}
  end

  def hierarchical_name_for_indexing
    hierarchical_name(' :: ')
  end
}

ActsAsTaggableOn::Tag.instance_eval{
  searchable do
    integer :id
    text :hierarchical_name_for_indexing, :stored => true
    string :hierarchical_name_for_indexing, :stored => true
    text :name, :default_boost => 2
    integer :ancestor_ids, :multiple => true
  end
}

