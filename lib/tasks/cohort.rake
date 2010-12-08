namespace :cohort do
  desc 'create some fake data'
  task(:fake_data => :environment) do
    (1..100).each do|i|
      c = Contact.create(:first_name => "First name #{i}", :last_name => "Last Name #{i}")
    end
    
    (1..50).each do |i|
      c = Contact.first(:order => 'random()')
      u = User.system_user
      n = Note.create(:note => "Note #{i}", :contact => c, :user => u)
    end
  end

  desc 'create berkman tags'
  task(:berkman_tag_contexts => :environment) do
    tags = YAML.load(File.open('data/tag_structure.yml'))
    tags.keys.each do|context|
      context_obj = TagContext.create!(
        :name => context, 
        :context => context.downcase.gsub(/\s/,'_'),
        :object_tagged => 'Contact'
      )
    end
  end
end
