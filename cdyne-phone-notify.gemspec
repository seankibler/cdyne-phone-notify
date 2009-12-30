# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cdyne-phone-notify}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean Kibler"]
  s.date = %q{2009-12-29}
  s.description = %q{Connector for the CDYNE PhoneNotify API.}
  s.email = %q{seankibler@skiblerspot.net}
  s.extra_rdoc_files = ["README.rdoc", "lib/phone_notify.rb"]
  s.files = ["Manifest", "README.rdoc", "Rakefile", "cdyne-phone-notify.gemspec", "lib/phone_notify.rb"]
  s.homepage = %q{http://github.com/skibler/cdyne-phone-notify}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Cdyne-phone-notify", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cdyne-phone-notify}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Connector for the CDYNE PhoneNotify API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
