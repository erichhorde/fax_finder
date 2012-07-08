require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "fax_finder"
    gem.summary = "Provides support MultiTech's FaxFinder server"
    gem.authors = ["Erich L. Timkar"]
    gem.email = "erich@hordesoftware.com"
    gem.homepage = "http://github.com/erichhorde/fax_finder"
    gem.rubyforge_project = "fax_finder"

    gem.add_dependency('nokogiri', '>=1.5')
    gem.add_dependency('builder', '>= 2.1.2')
    gem.add_development_dependency('test-unit', '~> 2')
    gem.add_development_dependency('mocha', '>= 0.9')

  end

  # Jeweler::RubyforgeTasks.new do |rubyforge|
  #   rubyforge.doc_task = "rdoc"
  # end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "fax_finder: Ruby Support for Multitech's FaxFinder Server"
  rdoc.rdoc_dir = 'rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end