namespace :cohort do

  desc 'index files'
  task(:index_files => :environment) do
    Document.for_indexing.each do|d|
      d.needs_indexing = false
      d.content = d.get_file_contents
      d.save
      d.contact.index
    end
  end

  desc 'initialize cohort base data'
  task(:init => :environment) do
    u = User.new(:email => 'importer-no-reply@example.com', :deleteable => false)
    u.create_random_password
    u.save
  end
  
  desc "default user"
  task(:default_user => :environment) do
    u = User.new(:email => 'admin@example.com')
    u.create_random_password
    u.save
    puts "User email is: #{u.email}"
    puts "User password is: #{u.password}"
  end

  desc 'create some fake data'
  task(:fake_data => :environment) do
    u = User.system_user
    (1..100).each do|i|
      c = Contact.new(:first_name => "First name #{i}", :last_name => "Last Name #{i}")
      c.accepts_role!(:owner, u)
    end
    
    (1..50).each do |i|
      c = Contact.first(:order => 'random()')
      n = Note.new(:note => "Note #{i}", :contact => c)
      n.accepts_role!(:owner,u)
      n.save
    end
  end

  desc 'create berkman tags'
  task(:berkman_tags => :environment) do
    academic_years = ['2007-08','2008-09','2009-10','2010-11','2011-12']

    all_berkman = ActsAsTaggableOn::Tag.create(:name => 'All Berkman')
    ['Affiliates', 'Alumni','Faculty','Fellows','Friends','Interns','Staff'].each do |sub_tag|
      tag = ActsAsTaggableOn::Tag.create(:name => sub_tag, :parent => all_berkman)
      if ['Fellows','Interns','Staff'].include?(sub_tag)
        academic_years.each do |year_tag|
          ActsAsTaggableOn::Tag.create(:name => year_tag, :parent => tag)
        end
      end
    end

    events = ActsAsTaggableOn::Tag.create(:name => 'Events')
    ['Luncheon Series','Law Lab Speaker Series','Digital Natives Forum Series','Cyberscholars','Guests','Meetings'].each do |event|
      ActsAsTaggableOn::Tag.create(:name => event, :parent => events)
    end

    projects = ActsAsTaggableOn::Tag.create(:name => 'Projects')
    ['Center for Citizen Media'].each do |project|
      ActsAsTaggableOn::Tag.create(:name => project, :parent => projects)
    end

    ActsAsTaggableOn::Tag.create(:name => 'Press')

    people = ActsAsTaggableOn::Tag.create(:name => 'People')
    ['Students','Intern Applicants','Fellowship Applicants'].each do |group|
      tag = ActsAsTaggableOn::Tag.create(:name => group, :parent => people)
      academic_years.each do |year_tag|
        ActsAsTaggableOn::Tag.create(:name => year_tag, :parent => tag)
      end
    end

    orgs = ActsAsTaggableOn::Tag.create(:name => 'Organizations')
    ['Networked organizations','Oxford Internet Institute','MIT','Stanford','University of St. Gallen','Aspen Institute','Gruter Institute','University of Toronto','Yale','Brown University','University of Berkeley California','Princeton University','New York University','Harvard University'].each do |org|
      tag = ActsAsTaggableOn::Tag.create(:name => org, :parent => orgs)
      if org == 'MIT'
        ActsAsTaggableOn::Tag.create(:name => 'Center for Future Civic Media', :parent => tag)
        ActsAsTaggableOn::Tag.create(:name => 'Comparative Media Studies', :parent => tag)
        ActsAsTaggableOn::Tag.create(:name => 'Media Lab', :parent => tag)
        ActsAsTaggableOn::Tag.create(:name => 'Center for Collective Intelligence', :parent => tag)
      elsif org == 'Stanford'
        ActsAsTaggableOn::Tag.create(:name => 'Center for Internet & Society', :parent => tag)
      elsif org == 'University of Toronto'
        ActsAsTaggableOn::Tag.create(:name => 'Citizen lab', :parent => tag)
      elsif org == 'Yale'
        ActsAsTaggableOn::Tag.create(:name => 'Information Society Project', :parent => tag)
      elsif org == 'Brown University'
        ActsAsTaggableOn::Tag.create(:name => 'Watson Center', :parent => tag)
      elsif org == 'University of Berkeley California'
        ActsAsTaggableOn::Tag.create(:name => 'Samuelson Clinic', :parent => tag)
      elsif org == 'Princeton University'
        ActsAsTaggableOn::Tag.create(:name => 'center for information technology policy', :parent => tag)
      elsif org == 'Harvard University'
        ['Provost','Office of Sponsored Partnerships','Harvard Law School','Harvard Kennedy School','Harvard Business School','Harvard College'].each do |dept|
          ActsAsTaggableOn::Tag.create(:name => dept, :parent => tag)
        end
      end
    end

    companies = ActsAsTaggableOn::Tag.create(:name => 'Companies')
    ['Microsoft','Google','IBM'].each do |corp|
      ActsAsTaggableOn::Tag.create(:name => corp, :parent => companies)
    end
    ActsAsTaggableOn::Tag.create(:name => 'Vendors')
    funders = ActsAsTaggableOn::Tag.create(:name => 'Funders / Foundations')
    ['MacArthur Foundation','Sloan Foundation','Kauffman Foundation','Prospective','Solid No'].each do |ff|
      ActsAsTaggableOn::Tag.create(:name => ff, :parent => funders)
    end

    special = ActsAsTaggableOn::Tag.create(:name => 'Special')
    autotags = ActsAsTaggableOn::Tag.create(:name => 'Autotags', :parent => special)
    never_email = ActsAsTaggableOn::Tag.create(:name => 'Never Email', :parent => special)
    never_contact = ActsAsTaggableOn::Tag.create(:name => 'Never Contact', :parent => special)
    never_phone = ActsAsTaggableOn::Tag.create(:name => 'Never Phone', :parent => special)
    uncategorized = ActsAsTaggableOn::Tag.create(:name => 'Uncategorized')
  end
end
