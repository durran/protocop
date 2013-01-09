# encoding: utf-8
require "./lib/protocop/version"

Gem::Specification.new do |s|
  s.name         = "protocop"
  s.version      = Protocop::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Durran Jordan"]
  s.email        = ["durran@gmail.com"]
  s.summary      = "A Ruby implementation of Google Protocol Buffers."
  s.description  = s.summary
  s.files        = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.extensions   = ["ext/protcop/extconf.rb"]
  s.require_path = "lib"
end
