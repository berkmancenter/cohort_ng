#require 'ftools'
# Install hook code here
puts "Installing ActsAsFreetaggable...\n"

# Generate db migration for tag and taggings?
puts "Copy migrations from the ActsAsFreetaggable plugin to your local rails migrations folder"
FileUtils.mkdir_p "#{RAILS_ROOT}/db/migrate"
Dir["#{File.dirname(__FILE__)}/db/migrate/*.rb"].each do |migration_path|
  migration = migration_path.split('/').last
  new_path = "#{RAILS_ROOT}/db/migrate/#{migration}"
  File.copy( migration_path, new_path)
  puts " Copied \"#{migration}\" to #{new_path}"
end
