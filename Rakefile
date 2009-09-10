require 'rubygems'
require 'date'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
require 'rake/gempackagetask'

include FileUtils

SPEC = Gem::Specification.new do |s|
  s.name = 'filebase'
  s.version = "0.3.11"
  s.rubyforge_project = 'filebase'
  s.summary = "Open-source framework for building Ruby-based Web applications."
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-04-30}
  s.email = %q{dan@zeraweb.com}
  s.executables = []
  s.files = Dir["lib/**/*.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/waves}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Simple file-based database with model support.}
  s.add_runtime_dependency( 'extensions', '=0.6.0')
	if defined?(RUBY_ENGINE) and RUBY_ENGINE == 'jruby'
  	s.add_runtime_dependency( 'json-jruby')
	else
		s.add_runtime_dependency('json', "=1.1.7")
	end
end

task :package => [ :gemspec ] do 
  Gem::Builder.new( SPEC ).build
end

task :clean do
  system 'rm -f *.gem *.gemspec'
end

task :install => :package do
  system 'sudo gem install ./*.gem'
end

desc "create .gemspec file (useful for github)"
task :gemspec => :clean do
  filename = "#{SPEC.name}.gemspec"
  File.open(filename, "w") do |f|
    f.puts SPEC.to_ruby
  end
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add([ 'README', 'lib/*.rb' ])
end

desc "run test suite to verify implementation"
task :test do
  paths = FileList['test/**/*.rb'].exclude('**/helpers.rb')
  command = "bacon #{paths.join(' ')}"
  system command
end
