gem 'activesupport', ">=2.3.8"
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run all specs'
task :default => :spec

desc 'Run all application-specific specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  # t.rcov = true
end

desc 'Generate documentation for the tabulator plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Tabulator'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
