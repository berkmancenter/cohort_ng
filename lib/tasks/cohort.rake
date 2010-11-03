namespace :cohort do
  desc 'create some fake data'
  task(:fake_data => :environment) do
    (1..100).each do|i|
      c = Contact.create(:first_name => "First name #{i}", :last_name => "Last Name #{i}")
    end
    
    (1..50).each do |i|
      c = Contact.all(:order => 'random()', :limit => 1)
      #FIXME
#      n = Note.
    end


  end
end
