# encoding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "protocop/version"

Gem::Specification.new do |s|
  s.name         = "protocop"
  s.version      = Protocop::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Durran Jordan"]
  s.email        = ["durran@gmail.com"]
  s.summary      = "A Ruby implementation of Google Protocol Buffers."
  s.description  = s.summary
  s.extensions   = ["ext/protcop/extconf.rb"]
  s.files        = Dir.glob("lib/**/*") + %w(README.md Rakefile)
  s.require_path = "lib"
end
