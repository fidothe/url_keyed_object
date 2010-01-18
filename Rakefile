require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "url_keyed_object"
    gem.summary = %Q{Making it easy to work with objects with URL keys}
    gem.description = %Q{Making it easy to work with Rails objects which use a URL key in their URL instead of their database ID.}
    gem.email = "matt@reprocessed.org"
    gem.homepage = "http://github.com/fidothe/url_keyed_object"
    gem.authors = ["Matt Patterson"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "cucumber", ">= 0.5"
    gem.add_development_dependency "activerecord", ">= 2.3"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'cucumber/rake/task'
  namespace :cucumber do
    Cucumber::Rake::Task.new(:ok, 'Run features that should pass') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'default'
    end
    
    Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'wip'
    end
    
    desc 'Run all features'
    task :all => [:ok, :wip]
  end
  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'
  
  task :default => :cucumber
  
  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end
rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "url_keyed_object #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
