# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{filebase}
  s.version = "0.3.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-04-30}
  s.email = %q{dan@zeraweb.com}
  s.files = ["lib/filebase.rb", "lib/filebase/attributes.rb", "lib/filebase/model.rb", "lib/filebase/drivers/mixin.rb", "lib/filebase/drivers/yaml.rb", "lib/filebase/drivers/marshal.rb", "lib/filebase/drivers/json.rb"]
  s.homepage = %q{http://dev.zeraweb.com/waves}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{filebase}
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Simple file-based database with model support.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<extensions>, ["= 0.6.0"])
      s.add_runtime_dependency(%q<json>, ["= 1.1.7"])
    else
      s.add_dependency(%q<extensions>, ["= 0.6.0"])
      s.add_dependency(%q<json>, ["= 1.1.7"])
    end
  else
    s.add_dependency(%q<extensions>, ["= 0.6.0"])
    s.add_dependency(%q<json>, ["= 1.1.7"])
  end
end
