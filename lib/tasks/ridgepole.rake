require 'ridgepole/rails/rake_task'

namespace :ridgepole do
  desc 'Export the database schema to Schemafile'
  Ridgepole::Rails::RakeTask.new('export')

  desc 'Apply Schemafile to the database'
  Ridgepole::Rails::RakeTask.new('apply')
end

Rake.application.lookup('db:migrate').clear
desc 'Migrate the database by Ridgepole'
task 'db:migrate' => %w(ridgepole:apply ridgepole:export)

Rake.application.lookup('db:schema:dump').clear
desc 'Export the database schema to Schemafile'
task 'db:schema:dump' => 'ridgepole:export'

Rake.application.lookup('db:schema:load').clear
desc 'Apply Schemafile to the database'
task 'db:schema:load' => 'ridgepole:apply'

Rake.application.lookup('db:test:load').clear
task 'db:test:load' => 'db:test:purge' do
  Rake::Task['ridgepole:apply'].invoke('test')
end

%w(db:migrate:status db:rollback db:version).each do |name|
  Rake.application.lookup(name).clear
end
